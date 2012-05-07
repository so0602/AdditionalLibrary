find . -name ".DS_Store" -exec rm -rf {} \;
git add .
git pull
git commit -a -m "Update" 
