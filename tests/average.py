import os
import matplotlib.pyplot as plt
from decimal import Decimal,getcontext
from matplotlib.font_manager import FontProperties
import numpy as np


matrices=[
    ['olafu', 0, 0,0,0,0,0],
    ['fd18', 0, 0,0,0,0,0],

    ['sme3Da', 0, 0,0,0,0,0],
    ['stokes64', 0, 0,0,0,0,0],

    ['Goodwin_030', 0, 0,0,0,0,0],
    ['cryg10000', 0, 0,0,0,0,0],

    ['sinc12', 0, 0,0,0,0,0],
    ['fd12', 0, 0,0,0,0,0],

    ['s3rmq4m1', 0, 0,0,0,0,0],
    ['freeFlyingRobot_12', 0, 0,0,0,0,0],

    ['bcsstk15', 0, 0,0,0,0,0],
    ['tols4000', 0, 0,0,0,0,0],

    ['ex36', 0, 0,0,0,0,0],
    ['iprob', 0, 0,0,0,0,0],

    ['MISKnowledgeMap', 0, 0,0,0,0,0],
    ['LeGresley_2508', 0, 0,0,0,0,0],

    ['piston', 0, 0,0,0,0,0],
    ['west2021', 0, 0,0,0,0,0],

    ['reorientation_2', 0, 0,0,0,0,0],
    ['netscience', 0, 0,0,0,0,0],

    ['collins_15NN', 0, 0,0,0,0,0],
    ['olm1000', 0, 0,0,0,0,0],

    ['mcfe', 0, 0,0,0,0,0],
    ['orbitRaising_3', 0, 0,0,0,0,0],
    
    # ['tomography', 0, 0,0,0,0,0]
]

extensions =[
    'avx',
    'noavx',
    'rvv',
    'norvv'
]
global matrix_name
global num_rows
global num_nonzero 
average=[]
boxplotdata=[]
for filename in matrices:
    boxplotdata=[]
    for extension in extensions:
        path = (f'measurements/{extension}{filename[0]}/{filename[0]}.txt')
        current_dir = os.path.dirname(os.path.abspath(__file__))
        file_path = os.path.join(current_dir, path)
        print(filename[0])
        with open(path, 'r') as file:
            data = file.read().strip().split(';')
        filename[1] = int(data[1])
        filename[2] = int(data[2])
        newdata=[np.float64(x[1:])*1000 for x in data[3:-1]]
        boxplotdata.append(newdata)
        
        # boxplotdata=newdata
        # plt.boxplot(boxplotdata)
        # plt.savefig("boxplot")
        avg_time = Decimal(data[-1]) if data[-1] else None
        getcontext().prec=6
        if extension == 'avx':
            filename[3]= avg_time
        elif extension == 'noavx':  
            filename[4]= avg_time
        elif extension == 'rvv':
            filename[5]= avg_time
        elif extension == 'norvv':
            filename[6]= avg_time
        else:
            print("error")
            exit
    plt.figure(figsize=(8, 6))
    plt.title(filename[0])
    plt.ylabel('Time ms.')
    plt.boxplot(boxplotdata)
    plt.xticks([1, 2, 3, 4], ['AVX', 'NOAVX', 'RVV', 'NORVV'])
    plt.savefig(f"normal/{filename[0]}")
    plt.close()
        
        # average.append(avg_time)


matrices_name = [x[0] for x in matrices]
matrices_rows = [x[1] for x in matrices]
matrices_nz = [x[2] for x in matrices]
matrices_avx = [np.round(np.float64(x[3])*1000,5) for x in matrices]
matrices_noavx = [np.round(np.float64(x[4])*1000,5) for x in matrices]
matrices_rvv = [np.round(np.float64(x[5])*1000,5) for x in matrices]
matrices_norvv = [np.round(np.float64(x[6])*1000,5) for x in matrices]
rvv_speedupar = []
avx_speedupar = []
table_data = []
for i in range(len(matrices_name)):
    avx_speedup = (matrices_noavx[i] - matrices_avx[i]) / matrices_noavx[i] * 100 if matrices_noavx[i] != 0 else 0
    rvv_speedup = (matrices_norvv[i] - matrices_rvv[i]) / matrices_norvv[i] * 100 if matrices_norvv[i] != 0 else 0
    avx_speedup = np.round(np.float64(avx_speedup),1)
    rvv_speedup = np.round(np.float64(rvv_speedup),1)
    rvv_speedupar.append(rvv_speedup)
    avx_speedupar.append(avx_speedup)
    coef = np.round(np.float64(matrices_nz[i]/(matrices_rows[i]*matrices_rows[i])),5)
    row = [f'{i+1}']
    row.extend([matrices_name[i],matrices_rows[i],matrices_nz[i],matrices_avx[i], matrices_noavx[i], matrices_rvv[i], matrices_norvv[i], avx_speedup, rvv_speedup])
    table_data.append(row)

font = FontProperties()
font.set_family('serif')
font.set_name('Times New Roman')

fig, ax = plt.subplots(figsize=(12, 10))

table = ax.table(cellText=table_data,
                colLabels=['№','Matrix name','Rows number' ,'Nonzeros' ,'AVX (ms.)', 'No AVX (ms.)', 'RVV (ms.)', 'No RVV (ms.)', 'AVX Speedup (%)', 'RVV Speedup (%)'],
                loc='center', cellLoc='center')

table.auto_set_font_size(False)
table.set_fontsize(10)
for i in range(24):
    print(i,":",matrices_avx[i],"&",matrices_noavx[i],"&",matrices_rvv[i],"&",matrices_norvv[i],"&",avx_speedupar[i],"&",rvv_speedupar[i])

# print("NOAVX:",[float(x) for x in matrices_noavx])
# print("AVX:",[float(x) for x in matrices_avx])
# print("NORVV:",[float(x) for x in matrices_rvv])
# print("RVV:",[float(x) for x in matrices_norvv])

for (i, j), cell in table.get_celld().items():
    if i == 0:
        cell.set_text_props(fontweight='bold', horizontalalignment='center')
        cell.set_text_props(wrap=True, font='serif', fontsize=10)
    else:
        cell.set_text_props(wrap=True, font='serif', fontsize=14)
    if j == 1:
        cell.set_width(0.17)
        cell.set_text_props(wrap=True, font='serif', fontsize=11)
    elif j == 0:
        cell.set_width(0.05)
        cell.set_text_props(wrap=True, font='serif', fontsize=11)
        
    if j == 9 and i != 0:
        avx_speedup = float(table_data[i-1][8])
        rvv_speedup = float(table_data[i-1][9])
        if rvv_speedup < 0:
            cell.set_facecolor('red')
        elif rvv_speedup > avx_speedup:
            cell.set_facecolor('lightgreen')
        else:
            cell.set_facecolor('lightcoral')
    if  j>1:
        cell.set_width(0.11)
    cell.set_height(0.04)
    cell.set_text_props()

# table.scale(1.5, 1.2)

ax.axis('off')

# plt.subplots_adjust(left=0.1, right=0.9, top=0.9, bottom=0.1)

fig.tight_layout()

path = (f'measurements/avg.png')
plt.savefig(path, dpi=300, bbox_inches='tight')
print(f"Graph saved into: {path}\n\n")
plt.close()