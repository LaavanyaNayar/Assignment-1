import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("isr_analysis.csv")

plt.figure(figsize=(8,5))
plt.plot(df["ISR_Time"], df["Overhead(%)"], marker='o', color='firebrick', label="Overhead %")
plt.xlabel("ISR Time")
plt.ylabel("Overhead (%)")
plt.title("System Overhead vs ISR Duration")
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()

