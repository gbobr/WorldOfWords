s/\\\*/\x01/g
s/\*\([^\*]*\)\*/\\e[1m\1\\e[21m/g
s/\x01/\*/g
s/\\_/\x01/g
s/_\([^_]*\)_/\\e[4m\1\\e[24m/g
s/\x01/_/g
s/\\-/\x01/g
s/-\([^-]*\)-/\\e[2m\1\\e[22m/g
s/\x01/-/g
