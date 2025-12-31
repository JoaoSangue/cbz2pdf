# cbz2pdf

I wrote this script because all the other solutions I could find either required uploading files to sketchy websites or learning how to ~~tolerate~~learn Calibre's interface.

This will work as long as [img2pdf](https://github.com/myollie/img2pdf) is installed and in your PATH.

Also, I haven't tried using this in any other shell than bash, but if you use a different one, you are probably knowledgeable enough to edit this to suit your needs.

## Usage

`cbz2pdf` works on one file at a time and can take up to three positional arguments:

* The input file (**required**)
* The author (**optional**)
* The title (**optional**, will use the input filename without the extension when omitted)

The author and title metadata is used by readers such as Apple Books.

### To convert a single file

```sh
cbz2pdf "input.cbz" "The Author" "A Descriptive Title"
```

### To convert multiple files at once

As mentioned above, this script only works on one file. To convert multiple files at once, I recommend making use of other Unix tools like `find`.\
For example, if you have a directory full of correctly named CBZ files and they all have the same author, you can do this:

```sh
find . -type f -name "*.cbz" -exec cbz2pdf "{}" "The Author" \;
```

This will convert all files in order, adding "The Author" as the author and using the filenames for the titles.
