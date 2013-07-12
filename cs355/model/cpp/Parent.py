import subprocess

parameters = [2, 4, 6, 8]
safeties = [0, 0.05, 0.1, 0.15, 0.2, 0.25]

str(0.34)
for i in parameters:
    for j in parameters:
        for k in safeties:
            for l in safeties:
                subprocess.call(['/home/acer/GIT/cs355/model/cpp/hello', str(i), str(j), str(k), str(l)])
