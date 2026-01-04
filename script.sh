#!/bin/sh


# Start SSH agent and add the key
eval "$(ssh-agent -s)"
ssh-add /home/u892791683/.ssh/hostinger_key


export HOME=/home/u892791683
export GIT_SSH_COMMAND='ssh -i /home/u892791683/.ssh/hostinger_key -o StrictHostKeyChecking=no'
cd /home/u892791683/domains/cicd_portfolio || exit 1
export PATH=/usr/bin:/bin


# ----- Log file -----
LOG_FILE=/home/u892791683/domains/cicd_portfolio/cron.log
echo "----- Cron run at $(date '+%Y-%m-%d %H:%M:%S') -----" >> $LOG_FILE




stylesheet=testStyle.css

push_to_github (){
    
    commitCount=$1
    commitMessage=$2


    if [ "$commitCount" = "first commit" ]; then
        [ ! -f "$stylesheet" ] && touch "$stylesheet"

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

    [ ! -d .git ] && /usr/bin/git init
    /usr/bin/git add .
    /usr/bin/git commit --allow-empty -m "$commitMessage"


    
   
    # Make sure the working tree is clean before pull
    /usr/bin/git reset --hard

    # Pull latest remote changes (rebase)
    /usr/bin/git pull origin master --rebase 2>&1 | tee -a $LOG_FILE || exit 1

    # Push
    /usr/bin/git push origin master 2>&1 | tee -a $LOG_FILE



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
