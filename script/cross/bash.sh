#!/bin/bash

rm /opt/ros2.repos
cd /opt/
rm -r ros2
git clone http://192.168.3.224:8081/nova-middleware/ros2.git 
cp ros2/ros2.repos ./


rm -r src nros rosbuild log 
mkdir src

echo $all_proxy
export all_proxy=socks5://192.168.7.193:7890

vcs import --input ros2.repos /opt/src

colcon build --base-paths "src" --build-base "rosbuild" --install-base "nros" --parallel-workers 1 --merge-install --packages-skip ros1_bridge --event-handlers console_cohesion+ console_package_list+ --cmake-args -DBUILD_TESTING=OFF --no-warn-unused-cli -DCMAKE_BUILD_TYPE=RelWithDebInfo -DINSTALL_EXAMPLES=OFF -DSECURITY=ON -DAPPEND_PROJECT_NAME_TO_INCLUDEDIR=ON

source /opt/nros/setup.bash
rm -r /opt/ros3rdbuild /opt/ros3rd

colcon build --base-paths "ros3rdsrc" --build-base "ros3rdbuild" --install-base "ros3rd" --parallel-workers 1 --merge-install --packages-skip ros1_bridge --event-handlers console_cohesion+ console_package_list+ --cmake-args -DBUILD_TESTING=OFF --no-warn-unused-cli -DCMAKE_BUILD_TYPE=RelWithDebInfo -DINSTALL_EXAMPLES=OFF -DSECURITY=ON -DAPPEND_PROJECT_NAME_TO_INCLUDEDIR=ON

rm /opt/R1nrosInstall/nros.tar.gz /opt/R1nrosInstall/ros3rd.tar.gz

tar -zcvf R1nrosInstall/nros.tar.gz nros/   
tar -zcvf R1nrosInstall/ros3rd.tar.gz ros3rd/

rm R1nrosInstall-$(date +%Y%m).tar.gz

tar -zcvf R1nrosInstall-$(date +%Y%m).tar.gz R1nrosInstall/

cd /root/arm/sysroot/opt/
rm -r nros ros3rd
cp -r /opt/nros ./
cp -r /opt/ros3rd ./
cd /root/
tar -zcvf arm.tar.gz arm
