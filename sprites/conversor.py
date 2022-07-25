import os

os.system("./bmpconv HOLE.BMP")

for i in range(1,13):
    os.system("./bmpconv ./PIN"+str(i)+".bmp")
