# SonarQube Docker Compose

SonarQube是一款用于代码质量管理的开源工具，它可用来快速定位代码中的Bug、漏洞以及不优雅的代码。

SonarQube支持的平台有Windows、Max OS、Liunx和Docker等。

默认情况下，SonarQube使用的是H2数据库，这是一款非常流行的嵌入式数据库。但生产环境中，SonarQube并不建议使用H2。SonarQube支持多种数据库，例如MySQL、Qracle、PostgreSQL、SQL Server等。从7.9版本开始，SonarQube只支持Oracle、SQLServer和PostgreSQL，MySQL不再支持。


本文将以PostgreSQL为例，在MacBook上通过docker-compose的方式来构建SonarQube环境。

## 技术栈

> 1. SonarQube 6.7.1
> 2. PostgreSQL 9.6
> 3. Nexus 3.16.2
> 4. Jenkins
> 5. JDK 8


## 先决条件

需要确保目标MacBook上已经安装完毕以下工具。

> 1. docker
> 2. docker-compose


## 操作说明

### 拉起SonarQube

在当前工程的根目录下打开命令行，执行quickstart.sh，将sonarqube服务拉起来。

```bash
./quickstart.sh
```

### 检测SonarQube

在浏览器输入http://localhost:9000，打开 SonarQube，默认用户名密码均为 admin;
登录sonarqube后，按照流程，依次需要做以下两件事情:
> 1. 创建一个令牌，我们需要记住这个令牌，它将在工程代码中被使用到
> 2. 设置分析参数，主要设置是工程代码所使用的编程语言和构建工具(我们推荐使用gradle构建工具)


### 添加Gradle配置

在工程代码的build.gradle文件中添加
```bash
apply plugin: 'java'
 
apply plugin: 'org.sonarqube'
 
sonarqube {
    properties {
        property "sonar.sourceEncoding", "UTF-8"
    }
}
 
 
buildscript {
    repositories { jcenter() }
    dependencies {
        classpath 'se.transmode.gradle:gradle-docker:1.2'
        classpath "org.sonarsource.scanner.gradle:sonarqube-gradle-plugin:2.7"
    }
}
 
 
sourceSets {
    main {
        java.srcDir('src/main/java')
        resources.srcDir('src/main/resources')
    }
    test {
        java.srcDir('src/test/java')
        resources.srcDir('src/test/resources')
    }
}
 
sonarqube {
    properties {
        property "sonar.sources", "src"
    }
```

在工程代码的gradle.properties文件中添加(systemProp.sonar.login为上文中的令牌)
```bash
systemProp.sonar.host.url=http://127.0.0.1:9000
systemProp.sonar.login=e538247b13ca612d495052fad7f7101dda1f531c
```

### 运行SonarQube命令
在工程代码的根目录下执行以下命令，对当前工程代码进行扫描：
```bash
$ ./gradlew sonarqube -x test
```
代码扫描结果会自动上传至sonarqube服务器。


### SonarQube与Jenkins集成
待补充




## 其他说明

> 1. 在database中需要明确定义postgres数据库的用户名、密码和数据库名。
> 2. 在sonarqube中的数据库的用户名、密码和数据库名要和database中的定义保持一致。
> 3. 由于sonarqube镜像有bug，需要同时用sonar.jdbc.xxx和SONARQUBE_JDBC_XXX指定数据库的用户名、密码和数据库名（否则会出现仍然使用默认的H2数据库的问题，或者打开sonarqube后发现Rules和Quality Profile为空的问题）。

### nexus
Login: admin
Pass: admin123


### jenkins
Login: admin
Password: admin


### sonarqube
http://localhost:9000/

Login: admin
Password: admin

### sonarqube和postgres兼容列表
sonarqube和postgres镜像也有版本兼容问题，经测试的兼容版本包括：

> 1. sonarqube:6.7.1 and postgres:9.6
> 2. sonarqube:6.4 and postgres:9.4
> 3. sonarqube:7.0 and postgres:9.6

### sonarqube汉化包兼容列表

Latest version: (https://github.com/SonarQubeCommunity/sonar-l10n-zh/releases/latest)

compatibility Matrix: 

**SonarQube** |**8.0**|       |       |       |       |       |       |       |       |       |
--------------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|
sonar-l10n-zh |8.0    |       |       |       |       |       |       |       |       |       |
**SonarQube** |**7.0**|**7.1**|**7.2**|**7.3**|**7.4**|**7.5**|**7.6**|**7.7**|**7.8**|**7.9**|
sonar-l10n-zh |1.20   |1.21   |1.22   |1.23   |1.24   |1.25   |1.26   |1.27   |1.28   |1.29   |
**SonarQube** |**6.0**|**6.1**|**6.2**|**6.3**|**6.4**|**6.5**|**6.6**|**6.7**|       |       |
sonar-l10n-zh |1.12   |1.13   |1.14   |1.15   |1.16   |1.17   |1.18   |1.19   |       |       |
**SonarQube** |       |       |       |       |**5.4**|**5.5**|**5.6**|       |       |       |
sonar-l10n-zh |       |       |       |       |1.9    |1.10   |1.11   |       |       |       |
**SonarQube** |**4.0**|**4.1**|       |       |       |       |       |       |       |       |
sonar-l10n-zh |1.7    |1.8    |       |       |       |       |       |       |       |       |
**SonarQube** |       |**3.1**|**3.2**|**3.3**|**3.4**|**3.5**|**3.6**|**3.7**|       |       |
sonar-l10n-zh |       |1.0    |1.1    |1.2    |1.3    |1.4    |1.5    |1.6    |       |       |


## 问题
Q: SonarQube运行一会后自动停止
A: SonarQube内置了Elastic Search来做代码静态分析，而Elastic Search会占用大量内存，可运行free -mh查看是否因为内存不足导致SonarQube崩溃。另外一个原因是，某些SonarQube的Dockerfile有问题，没有设置以非root账号运行SonarQube，而SonarQube只能以非root账号运行。

  当我们将Sonar作为容器运行时,我们遇到过这种问题,并且我们试图限制Sonar容器可用于2GB或RAM以下的最大内存。Sonar在引擎盖下运行Elasticsearch需要大量内存,因此在这种情况下,我建议为Sonar分配更多的2GB内存。

  我们还可以尝试通过ES_JAVA_OPTS将内存限制在2GB以下(如果您的内存服务器有限),但是当我尝试使用此选项时,Sonar启动成功,但经过一段时间后,一些流量问题返回并且容器已停止。这个链接提到的有关内存问题的解决方案是有效的：https://github.com/10up/wp-local-docker/issues/6，即增加Docker服务器(容器)的内存。

