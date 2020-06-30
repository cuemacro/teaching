# This script has some functionality to help with Jupyter notebook creation

# At present if offers
# - copying files between folders (and renaming)
# - ability to strip out code in the input boxes from Jupyter notebooks (other than code comments with # tag)

import glob
import sys

import os

from shutil import copyfile


def _get_input_file_list(input_file_list):

    if '*' in input_file_list:
        input_file_list = glob.glob(input_file_list)

    if  not(isinstance(input_file_list, list)):
        input_file_list = [input_file_list]

    return input_file_list

def copy_files(source, destination, strip_file_name=None):

    if '*' in source:
        source = glob.glob(source)

    for source_path in source:
        head, tail = os.path.split(source_path)

        old_tail = tail

        if strip_file_name is not None:
            tail = tail.replace(strip_file_name, '')

        source_path = os.path.join(head, old_tail)
        destination_path = os.path.join(destination, tail)

        if os.path.exists(destination_path):
            # in case of the src and dst are the same file
            if os.path.samefile(source_path, destination_path):
                continue

            os.remove(destination_path)

        copyfile(source_path, destination_path)

def strip_input_code_from_ipynb(input_file_list):

    # get list of files (including wildcards)
    input_file_list = _get_input_file_list(input_file_list)

    for input_file in input_file_list:
        with open(input_file, 'r', encoding="utf8") as f:
            contents = f.read()

        import json
        nb = json.loads(contents)

        for i in range(0, len(nb['cells'])):
            if 'source' in nb['cells'][i].keys() and nb['cells'][i]["cell_type"] == 'code':

                new_source = []

                for j in range(0, len(nb['cells'][i]['source'])):

                    pot_str = nb['cells'][i]['source'][j].strip()

                    if len(pot_str) >= 1:
                        if '#' == pot_str[0]:
                            try:
                                pot2 = pot_str[1]
                            except:
                                pot2 = ''

                            if pot2 != '#':
                                new_source.append(nb['cells'][i]['source'][j])

                        # print(nb['cells'][i]['source'][j])

                nb['cells'][i]['source'] = new_source

        # We write the Jupyter notebook back to disk with Python code stripped from the input boxes
        with open(input_file, 'w') as json_file:
            json.dump(nb, json_file)


def tidy_reveal_js_slides(input_file_list):

    # get list of files (including wildcards)
    input_file_list = _get_input_file_list(input_file_list)

    for input_file in input_file_list:
        with open(input_file, 'r', encoding='utf-8') as f:
            contents = f.read()

        # replace font and remove transitions (add any of your changes here too!)
        contents.replace('"slide"', '"none"')
        contents.replace('Helvetica Neue', 'Open Sans Light')

        # We write the Jupyter notebook back to disk with Python code stripped from the input boxes
        with open(input_file, 'w', encoding='utf-8') as f:
            f.write(contents)
            print("written")

if __name__ == '__main__':

    print(sys.argv[1])
    print(sys.argv[2])

    if sys.argv[1] == '--strip-python-code':
        strip_input_code_from_ipynb(sys.argv[2])
    elif sys.argv[1] == '--tidy-reveal-js-slides':
        tidy_reveal_js_slides(sys.argv[2])
    elif sys.argv[1] == '--copy-files':
        copy_files(sys.argv[2], sys.argv[3], strip_file_name=sys.argv[4])