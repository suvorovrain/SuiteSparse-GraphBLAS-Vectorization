import sys
import os
import matplotlib.pyplot as plt
from decimal import Decimal,getcontext
filename = sys.argv[1] 
extensions =[
    'avx',
    'noavx',
    # 'rvv',
    # 'norvv'
]
global matrix_name
global num_rows
global num_nonzero 
average=[]
for extension in extensions:
    path = (f'measurements/{extension}{filename}/{filename}.txt')
    current_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(current_dir, path)
    with open(path, 'r') as file:
        data = file.read().strip().split(';')
    matrix_name = str(data[0])
    num_rows = int(data[1])
    num_nonzero = int(data[2])
    getcontext().prec=6
    avg_time = Decimal(data[-1]) if data[-1] else None
    average.append(avg_time)

print(len(average))
plt.figure(figsize=(12, 8))
bars =plt.bar(range(len(average)), average, edgecolor='black')
for bar in bars:
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2., height,
             f'{height}',
             ha='center', va='bottom')

plt.title(f'Matrix: {filename}\n Number of rows : {num_rows}, Nonzero elements: {num_nonzero}')
plt.xlabel('Time s.')
plt.ylabel('Number of tests')
plt.grid(True)

plt.xticks(range(len(extensions)), extensions)

for extension in extensions:
    path = (f'measurements/{extension}{filename}/{filename}.txt')
    current_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(current_dir, path)
    plot_filename = os.path.splitext(path)[0] + '_avgplot.png'
    plt.savefig(os.path.join(current_dir, plot_filename))
    plt.close()
    print(f"Graph saved into: {plot_filename}\n\n")
