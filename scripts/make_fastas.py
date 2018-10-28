import sys
import os
from random import choice, seed, randint, normalvariate

OUTDIR = sys.argv[1]
NUM_FASTAS = int(sys.argv[2])
ALPHABET = 'ATGC'
SEQ_LEN = 1000
LINE_LEN = 60

# Set random seed so that output is reproducible
SEED = 20180709
seed(SEED)

def sample_with_replacement(alphabet=ALPHABET, seq_len=SEQ_LEN):
    '''
    Sample from alphabet with replacement seq_len times and
    return as a string
    '''
    return ''.join([choice(alphabet) for x in range(seq_len)])

def add_line_breaks(seq, line_len=LINE_LEN):
    new_seq = ''
    for i in range(int(len(seq) / line_len) + 1):
        cur_chunk = sequence[LINE_LEN*i:]
        if len(cur_chunk) > LINE_LEN:
            new_seq += cur_chunk[:line_len] + '\n'
        else:
            new_seq += cur_chunk
    return new_seq

def draw_seq_length(mean=SEQ_LEN):
    return int(normalvariate(mean, mean/9))

# Create NUM_FASTAS files with random sequences
for n in range(NUM_FASTAS):
    with open(os.path.join(OUTDIR, 'file' + str(n) + '.fasta'), 'w') as f:
        f.write('>seq' + str(n) + '\n')
        sequence = sample_with_replacement(seq_len=draw_seq_length())
        sequence = add_line_breaks(sequence)
        f.write(sequence)
