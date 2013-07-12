
a = []
b = [0, 5]
c = [9, 3]
d = [3, 5]
e = [2, 0]
f = [1, 1]

a.append(b)
a.append(c)
a.append(d)
a.append(e)
a.append(f)

a.sort(key=lambda x: x[1])
print e[len(e)-1]
print a
print len(a)
