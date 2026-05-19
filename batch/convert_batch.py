#!/usr/bin/env python3
"""
convert_batch.py — Conversion batch DOCX/PPTX/PDF → Markdown
pandoc-macos-toolkit — Antea Group

Usage :
  python3 convert_batch.py --mode fast                   # DOCX + PPTX via pandoc
  python3 convert_batch.py --mode ai                     # PDF via marker (lent)
  python3 convert_batch.py --mode all                    # les trois formats
  python3 convert_batch.py --mode fast --dry-run         # lister sans convertir
  python3 convert_batch.py --mode fast --workers 2       # limiter à 2 jobs
"""

import argparse
import concurrent.futures
import csv
import json
import re
import subprocess
import sys
import zipfile
import xml.etree.ElementTree as ET
from datetime import datetime
from pathlib import Path

# ---------------------------------------------------------------------------
# Constantes
# ---------------------------------------------------------------------------

BASE_DIR       = Path("/Volumes/Andromede/fiches_de_cas_antea")
OUTPUT_DIR     = BASE_DIR / "markdown"
DIR_PPTS       = BASE_DIR / "ppts"
DIR_PDFS       = BASE_DIR / "pdfs"
VENV_MARKER    = Path("/Users/marcou/Documents/Obsidian Vault/03-PROJETS/Dev/.venv-marker")
MARKER_BIN     = VENV_MARKER / "bin" / "marker_single"
LOG_CSV        = Path(__file__).parent / "conversion_log.csv"
MAX_WORKERS    = 4

# ---------------------------------------------------------------------------
# Post-traitement PPTX
# ---------------------------------------------------------------------------

def postprocess_pptx(path: Path) -> None:
  text = path.read_text(encoding='utf-8', errors='replace')
  text = re.sub(r'<!--.*?-->', '', text, flags=re.DOTALL)

  def keep_alt(m):
    alt = m.group(1).strip()
    return alt if alt else ''

  text = re.sub(r'!\[(.*?)\]\(ppt/media/[^)]+\)', keep_alt, text, flags=re.DOTALL)
  text = re.sub(r'^- $', '', text, flags=re.MULTILINE)
  text = re.sub(r'\n{3,}', '\n\n', text)
  path.write_text(text.strip() + '\n', encoding='utf-8')


# ---------------------------------------------------------------------------
# Post-traitement DOCX (aplatissement tableaux Word)
# ---------------------------------------------------------------------------

def postprocess_docx(path: Path) -> None:
  lines = path.read_text(encoding='utf-8', errors='replace').splitlines(keepends=True)
  out = []
  for line in lines:
    if re.match(r'^\s*[+|][+\-=|: ]+$', line):
      continue
    if line.startswith('|'):
      cells = [c.strip() for c in line.split('|')
               if c.strip() and c.strip() not in ('[]', '[ ]')]
      if cells:
        out.extend(c + '\n' for c in cells)
      continue
    line = re.sub(r'!\[(.*?)\]\([^)]+\)', lambda m: m.group(1).strip(), line, flags=re.DOTALL)
    if re.match(r'^- $', line.strip()):
      continue
    line = re.sub(r'<!--.*?-->', '', line, flags=re.DOTALL)
    out.append(line)
  text = ''.join(out)
  text = re.sub(r'\n{3,}', '\n\n', text)
  path.write_text(text.strip() + '\n', encoding='utf-8')


# ---------------------------------------------------------------------------
# Comptages
# ---------------------------------------------------------------------------

def count_pages_docx(filepath: Path) -> str:
  try:
    with zipfile.ZipFile(filepath) as z:
      with z.open('docProps/app.xml') as f:
        tree = ET.parse(f)
        ns = {'ep': 'http://schemas.openxmlformats.org/officeDocument/2006/extended-properties'}
        pages = tree.find('.//ep:Pages', ns)
        return pages.text if pages is not None else '-'
  except Exception:
    return '-'


def count_slides_pptx(filepath: Path) -> str:
  try:
    with zipfile.ZipFile(filepath) as z:
      count = sum(1 for n in z.namelist()
                  if n.startswith('ppt/slides/slide') and n.endswith('.xml'))
    return str(count)
  except Exception:
    return '-'


def count_pages_pdf_meta(meta_path: Path) -> str:
  try:
    with open(meta_path) as f:
      d = json.load(f)
    return str(len(d.get('page_stats', [])))
  except Exception:
    return '-'


# ---------------------------------------------------------------------------
# Manifest (log CSV de reprise)
# ---------------------------------------------------------------------------

LOG_FIELDS = ['timestamp', 'status', 'duration', 'count', 'engine', 'filename', 'output']


def load_done() -> set:
  """Retourne les noms de fichiers déjà convertis avec statut OK."""
  done = set()
  if LOG_CSV.exists():
    with open(LOG_CSV, newline='', encoding='utf-8') as f:
      for row in csv.DictReader(f):
        if row.get('status') == 'OK':
          done.add(row['filename'])
  return done


def append_log(row: dict) -> None:
  write_header = not LOG_CSV.exists()
  with open(LOG_CSV, 'a', newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=LOG_FIELDS)
    if write_header:
      writer.writeheader()
    writer.writerow(row)


def make_row(filename: str, status: str, duration: int,
             count: str, engine: str, output: str) -> dict:
  return {
    'timestamp': datetime.now().strftime('%Y-%m-%d %H:%M'),
    'status': status,
    'duration': duration,
    'count': count,
    'engine': engine,
    'filename': filename,
    'output': output,
  }


# ---------------------------------------------------------------------------
# Conversions
# ---------------------------------------------------------------------------

def convert_docx(filepath: Path, output_dir: Path = OUTPUT_DIR) -> dict:
  output = output_dir / f"{filepath.stem}.md"
  start = datetime.now()
  try:
    result = subprocess.run(
      ['nice', '-n', '10', 'pandoc', str(filepath), '-t', 'plain', '--wrap=none', '-o', str(output)],
      capture_output=True, text=True
    )
    if result.returncode != 0 or not output.exists():
      raise RuntimeError(result.stderr.strip())
    postprocess_docx(output)
    count = count_pages_docx(filepath)
    status = 'OK'
  except Exception:
    status = 'FAIL'
    count = '-'
  duration = int((datetime.now() - start).total_seconds())
  return make_row(filepath.name, status, duration, count, 'pandoc', str(output))


def convert_pptx(filepath: Path, output_dir: Path = OUTPUT_DIR) -> dict:
  output = output_dir / f"{filepath.stem}.md"
  start = datetime.now()
  try:
    result = subprocess.run(
      ['nice', '-n', '10', 'pandoc', str(filepath), '--wrap=none', '-o', str(output)],
      capture_output=True, text=True
    )
    if result.returncode != 0 or not output.exists():
      raise RuntimeError(result.stderr.strip())
    postprocess_pptx(output)
    count = count_slides_pptx(filepath)
    status = 'OK'
  except Exception:
    status = 'FAIL'
    count = '-'
  duration = int((datetime.now() - start).total_seconds())
  return make_row(filepath.name, status, duration, count, 'pandoc', str(output))


LIBREOFFICE = Path("/Applications/LibreOffice.app/Contents/MacOS/soffice")


def convert_ppt_legacy(filepath: Path, output_dir: Path = OUTPUT_DIR) -> dict:
  """Convertit les fichiers .ppt (format binaire) via LibreOffice → pptx → pandoc."""
  tmp_dir = Path("/tmp/ppt_convert")
  tmp_dir.mkdir(exist_ok=True)
  tmp_pptx = tmp_dir / f"{filepath.stem}.pptx"
  start = datetime.now()
  try:
    if not LIBREOFFICE.exists():
      raise FileNotFoundError("LibreOffice introuvable")
    result = subprocess.run(
      ['nice', '-n', '10', str(LIBREOFFICE), '--headless',
       '--convert-to', 'pptx', '--outdir', str(tmp_dir), str(filepath)],
      capture_output=True, text=True
    )
    if not tmp_pptx.exists():
      raise RuntimeError(result.stderr.strip()[:200])
    row = convert_pptx(tmp_pptx, output_dir)
    # Corriger le nom du fichier dans le log (source = .ppt original)
    row['filename'] = filepath.name
    row['duration'] = int((datetime.now() - start).total_seconds())
    tmp_pptx.unlink(missing_ok=True)
    return row
  except Exception as exc:
    duration = int((datetime.now() - start).total_seconds())
    return make_row(filepath.name, 'FAIL', duration, '-', 'libreoffice', '')


def convert_pdf(filepath: Path) -> dict:
  # marker_single crée {output_dir}/{stem}/{stem}.md
  output_parent = filepath.parent
  md_path = output_parent / filepath.stem / f"{filepath.stem}.md"
  start = datetime.now()
  try:
    if not MARKER_BIN.exists():
      raise FileNotFoundError(f"marker_single introuvable : {MARKER_BIN}")
    result = subprocess.run(
      ['nice', '-n', '10', str(MARKER_BIN), str(filepath),
       '--output_dir', str(output_parent), '--disable_image_extraction'],
      capture_output=True, text=True
    )
    if not md_path.exists():
      raise RuntimeError(result.stderr.strip()[:200])
    meta_path = output_parent / filepath.stem / f"{filepath.stem}_meta.json"
    count = count_pages_pdf_meta(meta_path)
    status = 'OK'
  except Exception:
    status = 'FAIL'
    count = '-'
    md_path = Path('')
  duration = int((datetime.now() - start).total_seconds())
  return make_row(filepath.name, status, duration, count, 'marker', str(md_path))


# ---------------------------------------------------------------------------
# Point d'entrée
# ---------------------------------------------------------------------------

def make_dispatch(output_dir: Path) -> dict:
  return {
    '.docx': lambda f: convert_docx(f, output_dir),
    '.pptx': lambda f: convert_pptx(f, output_dir),
    '.ppt':  lambda f: convert_ppt_legacy(f, output_dir),
    '.pdf':  convert_pdf,
  }


def collect_files(mode: str, source_dir: Path | None) -> list[Path]:
  if source_dir:
    dirs = [source_dir]
  else:
    dirs = []
    if mode in ('fast', 'all'):
      dirs.append(DIR_PPTS)
    if mode in ('ai', 'all'):
      dirs.append(DIR_PDFS)

  exts = set()
  if mode in ('fast', 'all'):
    exts.update(['.docx', '.pptx', '.ppt'])
  if mode in ('ai', 'all'):
    exts.add('.pdf')

  files = []
  for d in dirs:
    if d.exists():
      files.extend(f for f in d.rglob('*') if f.suffix.lower() in exts)
  return sorted(files)


def main() -> None:
  parser = argparse.ArgumentParser(
    description='Conversion batch DOCX/PPTX/PDF → Markdown — pandoc-macos-toolkit'
  )
  parser.add_argument('--mode', choices=['fast', 'ai', 'all'], default='fast',
                      help='fast=DOCX+PPTX (pandoc) | ai=PDF (marker) | all=les trois')
  parser.add_argument('--dir', type=Path, default=None,
                      help='Dossier source à scanner (remplace les dossiers par défaut)')
  parser.add_argument('--output-dir', type=Path, default=OUTPUT_DIR,
                      help='Dossier de sortie DOCX/PPTX (défaut: .../markdown)')
  parser.add_argument('--workers', type=int, default=MAX_WORKERS,
                      help='Jobs parallèles max — recommandé : 4 (fast), 1-2 (ai — marker charge des modèles IA lourds)')
  parser.add_argument('--dry-run', action='store_true',
                      help='Lister les fichiers à traiter sans convertir')
  args = parser.parse_args()

  if args.mode == 'ai' and args.workers > 2:
    print(f"⚠️  mode ai : {args.workers} workers — marker est intensif CPU/RAM, 1-2 recommandés")

  output_dir = args.output_dir
  if not output_dir.exists() and args.mode in ('fast', 'all'):
    print(f"❌ Dossier de sortie introuvable : {output_dir}")
    sys.exit(1)

  done = load_done()
  files = collect_files(args.mode, args.dir)
  files = [f for f in files if f.name not in done]

  if not files:
    print("✅ Aucun fichier à traiter (tous déjà convertis ou dossier vide)")
    return

  total = len(files)
  print(f"📂 {total} fichier(s) — mode={args.mode} — workers={args.workers}")
  if done:
    print(f"   (déjà OK dans le manifest : ignorés)")

  if args.dry_run:
    for f in files:
      print(f"  {f.name}")
    return

  dispatch = make_dispatch(output_dir)
  ok = fail = 0
  durations: list[int] = []
  errors: list[str] = []
  start_batch = datetime.now()
  # Résumé périodique toutes les N lignes (utile pour les longs batches PDF)
  summary_every = 50 if args.mode == 'ai' else 200

  with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as pool:
    futures = {pool.submit(dispatch[f.suffix.lower()], f): f for f in files}
    for i, future in enumerate(concurrent.futures.as_completed(futures), 1):
      filepath = futures[future]
      try:
        row = future.result()
      except Exception as exc:
        row = make_row(filepath.name, 'FAIL', 0, '-', '?', '')
        errors.append(f"{filepath.name} — exception : {exc}")
      append_log(row)

      if row['status'] == 'OK':
        ok += 1
        durations.append(row['duration'])
      else:
        fail += 1
        if row['status'] == 'FAIL':
          errors.append(f"{row['filename']} ({row['engine']})")

      # Calcul ETA
      remaining = total - i
      if durations:
        avg = sum(durations) / len(durations)
        eta_s = int(avg * remaining / args.workers)
        eta_str = f"  ETA ~{eta_s // 60}m{eta_s % 60:02d}s" if eta_s > 10 else ""
      else:
        eta_str = ""

      icon = '✅' if row['status'] == 'OK' else '❌'
      print(f"[{i}/{total}] {icon} {row['filename']}  ({row['duration']}s, {row['count']}){eta_str}")

      # Résumé périodique
      if i % summary_every == 0:
        elapsed = int((datetime.now() - start_batch).total_seconds())
        print(f"\n  ── Bilan {i}/{total} ── OK={ok}  FAIL={fail}  Restants={remaining}"
              f"  Temps écoulé={elapsed // 60}m{elapsed % 60:02d}s{eta_str}")
        if errors:
          print(f"  Erreurs récentes : {', '.join(errors[-3:])}")
        print()

  elapsed_total = int((datetime.now() - start_batch).total_seconds())
  print(f"\n{'─' * 52}")
  print(f"Terminé  OK={ok}  FAIL={fail}  Total={total}  Durée={elapsed_total // 60}m{elapsed_total % 60:02d}s")
  if errors:
    print(f"\nFichiers en erreur ({len(errors)}) :")
    for e in errors:
      print(f"  ❌ {e}")
  print(f"\nLog  {LOG_CSV}")


if __name__ == '__main__':
  main()
