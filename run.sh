#!/bin/bash

mkdir -p compiled images

for i in sources/*.txt tests/*.txt; do
	echo "Compiling: $i"
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done


# TODO

echo "Testing the transducer 'converter' with the input 'tests/numeroR.txt' (generating pdf)"
fstcompose compiled/numeroR.fst compiled/converter.fst | fstshortestpath > compiled/numeroA.fst

#----------------------------------PART 2-------------------------------------

#----A2R---------
fstinvert compiled/R2A.fst > compiled/A2R_transducer.fst

#----BirthR2A------
fstcompose compiled/R2A.fst compiled/d2dd.fst > compiled/birthR2A_intermediate.fst
fstconcat compiled/BirthR2A_intermediate.fst compiled/copy.fst > compiled/birthR2A_intermediate2.fst
fstcompose compiled/R2A.fst compiled/d2dd.fst > compiled/birthR2A_intermediate3.fst
fstconcat compiled/birthR2A_intermediate2.fst compiled/birthR2A_intermediate3.fst > compiled/birthR2A_intermediate4.fst
fstconcat compiled/birthR2A_intermediate4.fst compiled/copy.fst > compiled/birthR2A_intermediate5.fst
fstcompose compiled/R2A.fst compiled/d2dd.fst > compiled/birthR2A_intermediate6.fst
fstconcat compiled/birthR2A_intermediate5.fst compiled/birthR2A_intermediate6.fst > compiled/birthR2A_transducer.fst

#-----BirthA2T------
fstconcat compiled/copy-2.fst compiled/copy.fst > compiled/birthA2T_intermediate.fst
fstconcat compiled/birthA2T_intermediate.fst compiled/mm2mmm.fst > compiled/birthA2T_intermediate2.fst
fstconcat compiled/birthA2T_intermediate2.fst compiled/copy.fst > compiled/birthA2T_intermediate3.fst
fstconcat compiled/birthA2T_intermediate3.fst compiled/copy-2.fst > compiled/birthA2T_transducer.fst

#-----BirthT2R------
fstinvert compiled/birthA2T_transducer.fst > compiled/invertedBirthA2T.fst
fstinvert compiled/birthR2A_transducer.fst > compiled/invertedBirthR2A.fst
fstcompose compiled/invertedBirthA2T.fst compiled/invertedBirthR2A.fst > compiled/birthT2R_transducer.fst

#----------------------------------PART 3 (TESTS)-------------------------------------
echo "Testing the transducer 'birthT2R' with the input 'tests/birthT2Rtest' (generating pdf)"
fstcompose compiled/1101315birthT2Rtest.fst compiled/birthT2R_transducer.fst | fstshortestpath > compiled/1101315birthT2R_output.fst
fstcompose compiled/101349birthT2Rtest.fst compiled/birthT2R_transducer.fst | fstshortestpath > compiled/101349birthT2R_output.fst

echo "Testing the transducer 'A2R' with the input 'tests/A2Rtest' (generating pdf)"
fstcompose compiled/A2Rtest.fst compiled/A2R_transducer.fst | fstshortestpath > compiled/A2R_output.fst

echo "Testing the transducer 'BirthR2A' with the input 'tests/birthR2Atest' (generating pdf)"
fstcompose compiled/1101315birthR2Atest.fst compiled/birthR2A_transducer.fst | fstshortestpath > compiled/1101315birthR2A_output.fst
fstcompose compiled/101349birthR2Atest.fst compiled/birthR2A_transducer.fst | fstshortestpath > compiled/101349birthR2A_output.fst

echo "Testing the transducer 'BirthA2T' with the input 'tests/birthA2Ttest' (generating pdf)"
fstcompose compiled/1101315birthA2Ttest.fst compiled/birthA2T_transducer.fst | fstshortestpath > compiled/1101315birthA2T_output.fst
fstcompose compiled/101349birthA2Ttest.fst compiled/birthA2T_transducer.fst | fstshortestpath > compiled/101349birthA2T_output.fst

for i in compiled/*.fst; do
	echo "Creating image: images/$(basename $i '.fst').pdf"
    fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done