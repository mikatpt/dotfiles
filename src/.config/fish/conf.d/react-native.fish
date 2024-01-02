if ! test -d "$HOME/Android"
    echo "$HOME/Android doesn't exist, skipping react native setup."
    return
end

if ! test -d "$HOME/.sdkman"
    echo "$HOME/.sdkman does not exist, skipping react native setup"
    return
end

set -x ANDROID_HOME "$HOME/Android"
set -x WSL_HOST (tail -1 /etc/resolv.conf | cut -d' ' -f2)
set -x ADB_SERVER_SOCKET tcp:$WSL_HOST:5037
set -x JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

fish_add_path $JAVA_HOME/bin
fish_add_path $ANDROID_HOME/tools/bin
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path (find ~/.sdkman/candidates/*/current/bin -maxdepth 0)
fish_add_path /mnt/c/Users/mikatpt/AppData/Local/Android/Sdk/tools
function sdk
    bash -c "source '$HOME/.sdkman/bin/sdkman-init.sh'; sdk $argv[1..]"
end
