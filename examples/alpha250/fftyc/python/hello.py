from koheron import connect
import numpy as np
from fft import FFT

client = connect('localhost', 'fftyc')
driver = FFT(client)

# Read buffer
print("\nContents of scratch space: ")
print(driver.get_ycscratch())

# Prepare data to write
data = np.arange(256,dtype=np.uint32)
#data = np.zeros(256, dtype=np.uint32)
print("\nData to write: ")
print(data)

# Write buffer
driver.set_ycscratch(data)

# Read buffer again
print("\nContents of scratch space now: ")
print(driver.get_ycscratch())