#!/usr/bin/env python3
# Script de correction automatique des tableaux Markdown mal formatés

import sys
import re

def fix_markdown_tables(content):
    """
    Corrige les tableaux Markdown en supprimant les retours à la ligne dans les cellules.
    """
    lines = content.split('\n')
    fixed_lines = []
    in_table = False
    current_row = ""
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # Détecter le début d'un tableau (ligne avec |)
        if '|' in line and not in_table:
            # Vérifier si c'est vraiment un tableau (a des séparateurs)
            if i + 1 < len(lines) and re.match(r'^\s*\|[\s:-]+\|', lines[i + 1]):
                in_table = True
                current_row = line.strip()
            else:
                fixed_lines.append(line)
        
        # Dans un tableau
        elif in_table:
            # Ligne de séparation (|---|---|)
            if re.match(r'^\s*\|[\s:-]+\|', line):
                if current_row:
                    fixed_lines.append(current_row)
                    current_row = ""
                fixed_lines.append(line)
            
            # Ligne vide ou sans | → fin du tableau
            elif line.strip() == "" or '|' not in line:
                if current_row:
                    fixed_lines.append(current_row)
                    current_row = ""
                fixed_lines.append(line)
                in_table = False
            
            # Ligne de données du tableau
            else:
                stripped = line.strip()
                
                # Si la ligne commence par |, c'est une nouvelle rangée
                if stripped.startswith('|'):
                    # Sauvegarder la rangée précédente
                    if current_row:
                        fixed_lines.append(current_row)
                    current_row = stripped
                
                # Sinon, c'est la continuation de la rangée précédente
                else:
                    # Enlever le | final s'il existe pour éviter les doublons
                    if current_row.endswith('|'):
                        current_row = current_row[:-1].strip()
                    # Ajouter un espace et le texte
                    current_row += " " + stripped
        
        # Hors tableau
        else:
            fixed_lines.append(line)
        
        i += 1
    
    # Dernière rangée si nécessaire
    if current_row:
        fixed_lines.append(current_row)
    
    return '\n'.join(fixed_lines)


def main():
    if len(sys.argv) != 3:
        print("Usage: python3 fix_markdown_tables.py input.md output.md")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    # Lire le fichier
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Corriger les tableaux
    fixed_content = fix_markdown_tables(content)
    
    # Écrire le résultat
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(fixed_content)
    
    print(f"✅ Fichier corrigé : {output_file}")
    print(f"📊 {len(content.split(chr(10)))} lignes → {len(fixed_content.split(chr(10)))} lignes")


if __name__ == "__main__":
    main()
