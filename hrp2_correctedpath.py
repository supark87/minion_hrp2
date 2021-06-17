import sys
import glob

Path = './barcode1_consensus.fasta'  # user has to change the path whith all the fasta files

 # user have to change the path

print("filename", '\t',"start_VDD",'\t',"Stop_CLRH",'\t', 'HRP3', '\t', "Ambiguit_check", '\t', "Length between start and stop", '\t', "total_length_of_repeats",'\t', "residues", '\t', "exon_1",'\t', "exon2_start", '\t', "type1",  '\t', "type2",'\t', "type3", '\t', "type4", '\t', "type5", '\t',  "type6", '\t', "type7",'\t', "type8", '\t' "type9", '\t' "type10",  '\t', "type11",'\t', "type12", '\t', "type13" '\t', "type14", '\t', "type30", '\t', "type31" )

print("---------", '\t', "-----------",'\t', "---------",'\t',"---------", '\t', "-----------",'\t', "---------",'\t',"---------", '\t', "-----------",'\t', "---------",'\t', "---------", '\t', "-----------",'\t', "---------",'\t', "-----------",'\t', "---------",'\t', "---------", '\t', "-----------",'\t', "---------")



#Path = '/Users/dhruvibenpatel/Desktop/Sophie/HRP2_Pacbio/New/*.fasta'

files = glob.glob(Path)
for name in files:

   with open (name) as f:
       n = 0
       contents = f.read()  # read the contents of the file
  # search for start and stop string for repeats.
       start_1 = "VDD"
       stop_1 = "CLRH"
       HRP3 = "ANHGFHFNLHDNNSHTLHHAKANACFDD"    #also look for HRP3 gene presence/absence

       if start_1 in contents:
           start = "VDD is present"
       else :
           start = "No VDD found"
       if stop_1 in contents:
           stop = "CLRH is present"
       else:
           stop = "No CLRH found"
       if HRP3 in contents:
           hrp3 = "HRP3 is present"
       else :
           hrp3 = "No HRP3"

        #count all the bases between start and stop codon
       try:
           start_len = contents.index("VDD")
           stop_len = contents.index("CLRH")
       except:
           all_dna = 0
       else:
           all_dna = len(contents[start_len : (stop_len + 4)]) - 7
           if "X" in contents[start_len : stop_len] :
               ambiguity = "TRUE"
           else:
               ambiguity = "False"
       #serch for the ambiguity



       #all_dna = contents[start_len : (stop_len + 4)]
       #print (contents)

       # count all repeats and ovelap repeats by substracting uniq repeats
       exon_1 = contents.count("MVSFSKNKVLSAAVFASVLLLDN")
       exon2_start = contents.count("NNSAFNNNLCSKNA")
       type1 = contents.count("AHHAHHVAD")
       type2 = contents.count("AHHAHHAAD")
       type3= contents.count("AHHAHHAAY")
       type5= contents.count("AHHAHHASD")
       type10= contents.count("AHHAAAHHATD")
       type11= contents.count("AHN")
       type12= contents.count("AHHAAAHHEAATH")
       type14= contents.count("AHHAHHATD")
       type30 = contents.count("AHHAVD")
       type31 = contents.count("SHHAAY")
       type7 = contents.count("AHHAAD") -  type2
       type8 = contents.count("AHHAAY") - type3
       type13 = contents.count("AHHASD") - type5
       type6 = contents.count("AHHATD") - (type10 + type14)
       type9 = contents.count("AAY") - (type8 + type3 + type31)

       total_AHH = 2*type1 + 2*type2 + 2*type3 + 2*type5 + 2*type10 + 2*type12 + 2*type14 + type7 + type8 + type13 + type6 + type30
       type4 = contents.count("AHH") - total_AHH

# total bases for all above repeat type
       total_bases = type1 * len("AHHAHHVAD") + type2 * len("AHHAHHAAD") + type3 * len("AHHAHHAAY") + type4 * len("AHH") + type5 * len("AHHAHHASD") + type6 *len("AHHATD") + type7 * len("AHHAAD")+ type8 * len("AHHAAY") + type9 * len("AAY") + type10 * len("AHHAAAHHATD") +type11 * len("AHN") + type12 * len("AHHAAAHHEAATH") + type13 * len("AHHASD") + type14 * len("AHHAHHATD") + type30 * len("AHHAVD") + type31 * len("SHHAAY")
       residue = all_dna - total_bases
   #print(f.name, '\t',exon_1,'\t', exon2_start, '\t', type1,  '\t', type2,'\t', type3,  '\t', type5,'\t', type10,  '\t', type11,'\t', type12,  '\t', type14, '\t', type7,'\t', type8,  '\t', type13,'\t', type6,  '\t', type9, '\t', type4)
   print(f.name, '\t', start , '\t', stop,'\t', hrp3,'\t',ambiguity, '\t', all_dna , '\t', total_bases, '\t', residue, '\t', exon_1,'\t', exon2_start, '\t', type1,  '\t', type2,'\t', type3, '\t', type4, '\t', type5,'\t', type6, '\t', type7,'\t', type8, '\t', type9, '\t', type10,  '\t', type11,'\t', type12, '\t', type13, '\t', type14, '\t', type30, '\t', type31)
