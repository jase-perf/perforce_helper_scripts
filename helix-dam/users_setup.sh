# ==================================================================================
#  This will make all the required users and groups for a DAM install
#  Comment out any you don't want.
# ==================================================================================

p4 group -o unlimited | sed 's/43200/unlimited/ ; s/^Users:/Users:\n
        p4search\n
        p4index\n
        dam-super\n
        anonymous/
' | p4 group -A -i

p4 protect -o | sed '$ a \ \ \ \ 
    read user anonymous * //...\n
    admin user p4search * //...\n
    admin user p4index * //...\n
    super user dam-super * //...
' | p4 protect -i

p4 user -o p4search | p4 user -i -f
p4 user -o p4index | p4 user -i -f
p4 user -o dam-super | p4 user -i -f
p4 user -o anonymous | p4 user -i -f

printf 'p@ssw0rd\np@ssw0rd\n' | p4 -u p4search passwd
printf 'p@ssw0rd\np@ssw0rd\n' | p4 -u p4index passwd
printf 'p@ssw0rd\np@ssw0rd\n' | p4 -u dam-super passwd
printf 'p@ssw0rd\np@ssw0rd\n' | p4 -u anonymous passwd