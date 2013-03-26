for DIR in bolding common_look meta-tag frames ; do
    (cd "$DIR" ;
        touch dest/my-document.pdf dest/my-non-existent-archive.tar.gz
        bash upload.sh
    )
done

(cd faq-l && bash upload.sh)
