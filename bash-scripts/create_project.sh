#!/bin/bash 

#set some variables
project=$1
underscore="_"
banner="_banner"
parent="_parent"
panel="_panel"
dimensions=$2
fla=".fla"
as=".as"


#copy the template into the workspace dir
cp -r ~/Documents/workspace/utils/template/flashtalkingtemplate/ ~/Desktop/$project/

#move into the fla dir
cd ~/Desktop/$project/libs/fla 

#change the names of the flas
mv Flashtalking_template_300x250_banner.fla ./$project$underscore$dimensions$banner$fla
mv Flashtalking_template_300x250_panel.fla ./$project$underscore$dimensions$panel$fla
mv Flashtalking_template_300x250_parent.fla ./$project$underscore$dimensions$parent$fla

#move into the src dir
cd ~/Desktop/$project/src

#change the names of the class files, the class definition, and constructor
cat Flashtalking_template_300x250_banner.as | sed -e 's/Flashtalking_template_300x250_banner/'"$project$underscore$dimensions$banner"'/g' > $project$underscore$dimensions$banner$as
cat Flashtalking_template_300x250_panel.as | sed -e 's/Flashtalking_template_300x250_panel/'"$project$underscore$dimensions$panel"'/g' > $project$underscore$dimensions$panel$as
cat Flashtalking_template_300x250_parent.as | sed -e 's/Flashtalking_template_300x250_parent/'"$project$underscore$dimensions$parent"'/g' > $project$underscore$dimensions$parent$as

#delete the old class files
rm Flashtalking_template_*

#move to the bin dir   
cd ../bin

#delete the old swfs
rm *.swf
