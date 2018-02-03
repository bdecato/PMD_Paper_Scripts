#!/bin/bash

## Get the dN/dS values from the ensembl orthology files I downloaded:

for i in Human*ensembl; do awk -F $'\t' '{print $1 "\t" $10 "\t" $11}' ${i} | sort -u -k1,1 | sort -k 1b,1 > ${i}.tojoin; done
for i in Human*Horse*ensembl; do awk -F $'\t' '{print $1 "\t" $10 "\t" $9}' ${i} | sort -u -k1,1 | sort -k 1b,1 > ${i}.tojoin; done
for i in Human*Cow*ensembl; do awk -F $'\t' '{print $1 "\t" $10 "\t" $9}' ${i} | sort -u -k1,1 | sort -k 1b,1 > ${i}.tojoin; done

## Join the dN/dS values with the genes inside and outside of PMDs, and summarize.

join Cow_genes_in_PMD.tojoin Human_Cow_ensembl.tojoin | awk '{print $0 "\tCow\tinside"}' >> dNdS_summary
join Cow_genes_out_PMD.tojoin Human_Cow_ensembl.tojoin | awk '{print $0 "\tCow\toutside"}' >> dNdS_summary

join Horse_genes_in_PMD.tojoin Human_Horse_ensembl.tojoin | awk '{print $0 "\tHorse\tinside"}' >> dNdS_summary
join Horse_genes_out_PMD.tojoin Human_Horse_ensembl.tojoin | awk '{print $0 "\tHorse\toutside"}' >> dNdS_summary

join Mouse_genes_in_PMD.tojoin Human_Mouse_ensembl.tojoin | awk '{print $0 "\tMouse\tinside"}' >> dNdS_summary
join Mouse_genes_out_PMD.tojoin Human_Mouse_ensembl.tojoin | awk '{print $0 "\tMouse\toutside"}' >> dNdS_summary

join Dog_genes_in_PMD.tojoin Human_Dog_ensembl.tojoin | awk '{print $0 "\tDog\tinside"}' >> dNdS_summary
join Dog_genes_out_PMD.tojoin Human_Dog_ensembl.tojoin | awk '{print $0 "\tDog\toutside"}' >> dNdS_summary

join Rhesus_genes_in_PMD.tojoin Human_Rhesus_ensembl.tojoin | awk '{print $0 "\tRhesus\tinside"}' >> dNdS_summary
join Rhesus_genes_out_PMD.tojoin Human_Rhesus_ensembl.tojoin | awk '{print $0 "\tRhesus\toutside"}' >> dNdS_summary

join SquirrelMonkey_genes_in_PMD.tojoin Human_SquirrelMonkey_ensembl.tojoin | awk '{print $0 "\tSquirrelMonkey\tinside"}' >> dNdS_summary
join SquirrelMonkey_genes_out_PMD.tojoin Human_SquirrelMonkey_ensembl.tojoin | awk '{print $0 "\tSquirrelMonkey\toutside"}' >> dNdS_summary

## Remove genes with no dN/dS observations

awk '{if(NF==5){print $0}}' dNdS_summary > temp; mv temp dNdS_summary 
