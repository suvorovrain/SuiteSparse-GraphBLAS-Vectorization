import os
import re
from itertools import zip_longest
import sys

def extract_numbers(line):
    return [float(x) for x in re.findall(r'\d+\.\d+', line)]

def compare_files(directories, subfolder_name, num_files=5):
    for file_index in range(num_files):
        file_name = f'res_{file_index}.txt'
        
        file_paths = [os.path.join(directory, subfolder_name, file_name) for directory in directories]
        
        print(f"\nComparing {file_name} across all directories:")
        
        files = [open(path, 'r') if os.path.exists(path) else None for path in file_paths]
        
        if all(file is None for file in files):
            print(f"  File {file_name} does not exist in any directory")
            continue
        
        for line_num, lines in enumerate(zip_longest(*[f for f in files if f is not None], fillvalue=None), 1):
            numbers = [extract_numbers(line) if line is not None else None for line in lines]
            
            if any(nums is None for nums in numbers):
                print(f"  Line {line_num}: Missing data in one or more files")
                exit
               
            if len(set(len(nums) for nums in numbers)) > 1:
                print(f"  Line {line_num}: Mismatch in number of values across files")
                exit
                
            for i in range(len(numbers[0])):
                values = [nums[i] for nums in numbers]
                if len(set(values)) == 1:
                    continue
                else:
                    print(f"  Line {line_num}, Value {i+1}: Mismatch - {', '.join(map(str, values))}")
                    exit
        
        for file in files:
            if file is not None:
                file.close()

subfolder_name = sys.argv[1]

directories = [
    'results/avxresults',
    'results/noavxresults',
    'results/rvvresults',
    'results/norvvresults'
]

compare_files(directories, subfolder_name, num_files=1)
