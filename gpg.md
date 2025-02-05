```sh
gpg --full-generate-key
gpg --K --keyid-format=long
gpg --armor --export ##############
git config --global user.signingkey  ##################
git config --global commit.gpgsign true
git config --global tag.gpgSign true
```
