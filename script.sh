#!/bin/sh


touch testStyle.css
stylesheet=testStyle.css

push_to_github (){
    
    commitCount=$1
    commitMessage=$2


    if [ "$commitCount" = "first commit" ]; then
        #append to css 
        echo ".testing { background-color: red; }" >> $stylesheet
        push_to_github_commands "$commitMessage"

    elif [ "$commitCount" = "second commit" ]; then
        sed -i '/\.testing { background-color: red; }/d' $stylesheet
        push_to_github_commands "$commitMessage"

    elif [ "$commitCount" = "third commit" ]; then
        echo ".testingClass { font-size: 200px; }" >> $stylesheet
        push_to_github_commands "$commitMessage"

    elif [ "$commitCount" = "fourth commit" ]; then
        sed -i '/\.testingClass { font-size: 200px; }/d' $stylesheet
        push_to_github_commands "$commitMessage"
    fi

}

push_to_github_commands(){
    commitMessage=$1

    [ ! -d .git ] && git init
    git add .
    git commit --allow-empty -m "$commitMessage"
    git push origin master
}





echo "-----making first commit-----"
push_to_github "first commit" "added to styling"

echo "-----making second commit-----"
push_to_github "second commit" "removed from styling"

echo "-----making third commit-----"
push_to_github "third commit" "re-added to styling"

echo "-----making fourth commit-----"
push_to_github "fourth commit" "removed from styling"



echo "-----making fifth commit-----"
push_to_github "first commit" "added to stylesheet"

echo "-----making sixth commit-----"
push_to_github "second commit" "removed from stylesheet"

echo "-----making seventh commit-----"
push_to_github "third commit" "re-added to stylesheet"

echo "-----making eighth commit-----"
push_to_github "fourth commit" "removed from stylesheet"



echo "-----making ninth commit-----"
push_to_github "first commit" "edited code"

echo "-----making tenth commit-----"
push_to_github "second commit" "updated code"

echo "-----making eleventh commit-----"
push_to_github "third commit" "removed from css"

echo "-----making twelfth commit-----"
push_to_github "fourth commit" "final updated css"

echo "-----All commit successfully made-----"
