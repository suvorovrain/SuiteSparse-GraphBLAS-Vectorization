import os
import matplotlib.pyplot as plt
from decimal import Decimal, getcontext, ROUND_HALF_DOWN
import matplotlib.ticker as ticker
import sys
from scipy import stats
import numpy as np

def read_and_plot(filename):
    current_dir = os.path.dirname(os.path.abspath(__file__))
    # print(current_dir)
    file_path = os.path.join(current_dir, filename)
    # print(file_path)
    # print(os.path.splitext(filename)[0])
    
    with open(file_path, 'r') as file:
        data = file.read().strip().split(';')
    
    getcontext().clamp=0
    getcontext().prec=15
    getcontext().rounding=ROUND_HALF_DOWN
    numbers = np.array([x for x in data[3:-1] if x],dtype=np.float64)

    normal_test = stats.normaltest(numbers)
    shapiro_test = stats.shapiro(numbers)
    mean = np.mean(numbers)
    std_dev = np.std(numbers,ddof=1)
    confidence_interval = stats.t.ppf(0.975, df=len(numbers)-1)*stats.sem(numbers)
    analysis_filename = os.path.splitext(filename)[0] + '_analysis.txt'
    with open(os.path.join(current_dir,analysis_filename), 'w') as f:
        if (normal_test.pvalue <= 0.05):
            f.write(f"BAD RESULT!: p-value is too low!\n Normal Test: statistic={normal_test.statistic}, p-value={normal_test.pvalue}\n")
        else:
            f.write(f"Normal Test: statistic={normal_test.statistic}, p-value={normal_test.pvalue}\n")
        if (shapiro_test.pvalue <= 0.05):
            f.write(f"BAD RESULT!: p-value is too low!\n Shapiro Test: statistic={shapiro_test.statistic}, p-value={shapiro_test.pvalue}\n")
        else:
            f.write(f"Shapiro Test: statistic={shapiro_test.statistic}, p-value={shapiro_test.pvalue}\n")
        f.write(f"Mean: {mean}\n")
        if (std_dev > 0.10):
            f.write(f"BAD RESULT!: Standard deviation is too big!\n Standard Deviation: {std_dev}\n")
        else:
            f.write(f"Standard Deviation: {std_dev}\n")
        f.write(f"95% Confidence Interval: {confidence_interval}\n")
    print(f"Results have been saved to {analysis_filename}")


    matrix_name = str(data[0])
    num_rows = int(data[1])
    num_nonzero = int(data[2])

    avg_time = Decimal(data[-1]) if data[-1] else None

    plt.figure(figsize=(12,8))

    plt.hist(numbers, bins=30, edgecolor='black')

    plt.title(f'Matrix: {matrix_name}\n Number of rows : {num_rows}, Nonzero elements: {num_nonzero}')
    plt.xlabel('Time s.')
    plt.ylabel('Number of tests')
    plt.grid(True)

    plt.gca().xaxis.set_major_formatter(ticker.FuncFormatter(lambda x, p: f"{x:.6f}"))
    plt.xticks(rotation=45)

    plot_filename = os.path.splitext(filename)[0] + '_plot.png'
    plt.savefig(os.path.join(current_dir, plot_filename))
    plt.close()
    
    print(f"Graph saved into: {plot_filename}\n\n")
    # if avg_time is not None:
    #     print(f"Average time: {avg_time:.2f}")

matrix_name = sys.argv[1]
extension_type = sys.argv[2]
read_and_plot(f'measurements/{extension_type}{matrix_name}/{matrix_name}.txt')