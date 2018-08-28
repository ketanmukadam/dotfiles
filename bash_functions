#Attributes :-->
#https://github.com/sirboldilox/dotfiles/blob/master/common/bashrc
#https://github.com/erwanjegouzo/dotfiles/blob/master/.bash_profile


# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Coloured man pages
# https://wiki.archlinux.org/index.php/Man_page
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

backup() { 
    source=$1 ; 
    rsync --relative --force --ignore-errors --no-perms --chmod=ugo=rwX \
    --delete --backup --backup-dir=$(date +%Y%m%d-%H%M%S)_Backup        \
    --whole-file -a -v $source/ ~/Backup ;                              \
  }

# Copies files under svn wich have been modified into another directory
function svnsyncfolder(){
if [ $# -lt 1 ]; then
        echo "1st paramater has to be the location for exporting the changes";
        return 0;
fi
target=$1;
if [ ! -d $target ]; then
        echo "The target directory doesn't exist, create it? [y/n]: "
        read createDir
        if [ $createDir == "y" ]; then
                mkdir $target
        fi
fi
svn status | grep '^[A-M]' | cut -c8- | while read f; do
        echo "=> $f";
        dir=`dirname $f`
        targetDir=$target/$dir
        if [ ! -d $targetDir ];then
                mkdir -p $targetDir
        fi
        cp $f $target/$dir
done
}

# Copies files under svn wich have been modified into another directory
function svnexport(){

if [ $# -lt 3 ]; then
        echo "1st paramater has to be the location for exporting the changes";
        return 0;
fi

rev1=$1;
rev2=$2;
target=$3;

echo $1

if [ ! -d $target ]; then
        echo "The target directory doesn't exist, create it? [y/n]: "
        read createDir
        if [ $createDir == "y" ]; then
                mkdir $target
        fi
fi

svn diff --summarize -r $rev1:$rev2 . | cut -c8- | while read f; do
        echo "=> $f";
        dir=`dirname $f`
        targetDir=$target/$dir
        if [ ! -d $targetDir ];then
                mkdir -p $targetDir
        fi
        cp $f $target/$dir
done
}

# Generates a tree view from the current directory
function tree(){
	pwd
	ls -R | grep ":$" |   \
	sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
}
