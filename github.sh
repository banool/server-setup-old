# INTERACTIVE
# Setup Github.

ssh-keygen -t rsa -b 4096 -C "danielporteous1@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub

# Confirm that the user has copied the key into Github.
read -p "Press any key once you've added the key to Github "
