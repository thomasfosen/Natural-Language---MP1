#!/bin/bash

fstcompile --isymbols=syms.txt --osymbols=syms.txt t.txt | fstarcsort > t.fst

fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt t.fst | dot -Tpdf > t.pdf
