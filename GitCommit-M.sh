find . -name ".DS_Store" -exec rm -rf {} \;
git add .
git pull

read -p "Comment: " comment
git commit -a -m "$comment "
