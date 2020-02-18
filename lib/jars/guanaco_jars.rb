# frozen_string_literal: true

# this is a generated file, to avoid over-writing it just delete this comment
begin
  require 'jar_dependencies'
rescue LoadError
  require 'io/netty/netty-buffer/4.1.37.Final/netty-buffer-4.1.37.Final.jar'
  require 'com/google/guava/guava/21.0/guava-21.0.jar'
  require 'com/fasterxml/jackson/datatype/jackson-datatype-jdk8/2.9.8/jackson-datatype-jdk8-2.9.8.jar'
  require 'io/ratpack/ratpack-test/1.7.6/ratpack-test-1.7.6.jar'
  require 'io/netty/netty-transport/4.1.37.Final/netty-transport-4.1.37.Final.jar'
  require 'org/javassist/javassist/3.22.0-GA/javassist-3.22.0-GA.jar'
  require 'io/netty/netty-handler/4.1.37.Final/netty-handler-4.1.37.Final.jar'
  require 'com/fasterxml/jackson/core/jackson-databind/2.9.8/jackson-databind-2.9.8.jar'
  require 'io/netty/netty-common/4.1.37.Final/netty-common-4.1.37.Final.jar'
  require 'io/netty/netty-transport-native-epoll/4.1.37.Final/netty-transport-native-epoll-4.1.37.Final-linux-x86_64.jar'
  require 'io/netty/netty-transport-native-unix-common/4.1.37.Final/netty-transport-native-unix-common-4.1.37.Final.jar'
  require 'io/netty/netty-codec-http/4.1.37.Final/netty-codec-http-4.1.37.Final.jar'
  require 'com/fasterxml/jackson/dataformat/jackson-dataformat-yaml/2.9.8/jackson-dataformat-yaml-2.9.8.jar'
  require 'io/netty/netty-tcnative/2.0.25.Final/netty-tcnative-2.0.25.Final-linux-x86_64.jar'
  require 'com/github/ben-manes/caffeine/caffeine/2.6.2/caffeine-2.6.2.jar'
  require 'org/slf4j/slf4j-simple/1.7.30/slf4j-simple-1.7.30.jar'
  require 'com/fasterxml/jackson/datatype/jackson-datatype-jsr310/2.9.8/jackson-datatype-jsr310-2.9.8.jar'
  require 'io/ratpack/ratpack-core/1.7.6/ratpack-core-1.7.6.jar'
  require 'com/fasterxml/jackson/core/jackson-annotations/2.9.0/jackson-annotations-2.9.0.jar'
  require 'io/netty/netty-resolver/4.1.37.Final/netty-resolver-4.1.37.Final.jar'
  require 'com/sun/activation/javax.activation/1.2.0/javax.activation-1.2.0.jar'
  require 'org/reactivestreams/reactive-streams/1.0.2/reactive-streams-1.0.2.jar'
  require 'org/slf4j/slf4j-api/1.7.30/slf4j-api-1.7.30.jar'
  require 'com/fasterxml/jackson/datatype/jackson-datatype-guava/2.9.8/jackson-datatype-guava-2.9.8.jar'
  require 'io/ratpack/ratpack-exec/1.7.6/ratpack-exec-1.7.6.jar'
  require 'io/ratpack/ratpack-base/1.7.6/ratpack-base-1.7.6.jar'
  require 'org/yaml/snakeyaml/1.23/snakeyaml-1.23.jar'
  require 'io/netty/netty-codec/4.1.37.Final/netty-codec-4.1.37.Final.jar'
  require 'com/fasterxml/jackson/core/jackson-core/2.9.8/jackson-core-2.9.8.jar'
end

if defined? Jars
  require_jar 'io.netty', 'netty-buffer', '4.1.37.Final'
  require_jar 'com.google.guava', 'guava', '21.0'
  require_jar 'com.fasterxml.jackson.datatype', 'jackson-datatype-jdk8', '2.9.8'
  require_jar 'io.ratpack', 'ratpack-test', '1.7.6'
  require_jar 'io.netty', 'netty-transport', '4.1.37.Final'
  require_jar 'org.javassist', 'javassist', '3.22.0-GA'
  require_jar 'io.netty', 'netty-handler', '4.1.37.Final'
  require_jar 'com.fasterxml.jackson.core', 'jackson-databind', '2.9.8'
  require_jar 'io.netty', 'netty-common', '4.1.37.Final'
  require_jar 'io.netty', 'netty-transport-native-epoll', 'linux-x86_64', '4.1.37.Final'
  require_jar 'io.netty', 'netty-transport-native-unix-common', '4.1.37.Final'
  require_jar 'io.netty', 'netty-codec-http', '4.1.37.Final'
  require_jar 'com.fasterxml.jackson.dataformat', 'jackson-dataformat-yaml', '2.9.8'
  require_jar 'io.netty', 'netty-tcnative', 'linux-x86_64', '2.0.25.Final'
  require_jar 'com.github.ben-manes.caffeine', 'caffeine', '2.6.2'
  require_jar 'org.slf4j', 'slf4j-simple', '1.7.30'
  require_jar 'com.fasterxml.jackson.datatype', 'jackson-datatype-jsr310', '2.9.8'
  require_jar 'io.ratpack', 'ratpack-core', '1.7.6'
  require_jar 'com.fasterxml.jackson.core', 'jackson-annotations', '2.9.0'
  require_jar 'io.netty', 'netty-resolver', '4.1.37.Final'
  require_jar 'com.sun.activation', 'javax.activation', '1.2.0'
  require_jar 'org.reactivestreams', 'reactive-streams', '1.0.2'
  require_jar 'org.slf4j', 'slf4j-api', '1.7.30'
  require_jar 'com.fasterxml.jackson.datatype', 'jackson-datatype-guava', '2.9.8'
  require_jar 'io.ratpack', 'ratpack-exec', '1.7.6'
  require_jar 'io.ratpack', 'ratpack-base', '1.7.6'
  require_jar 'org.yaml', 'snakeyaml', '1.23'
  require_jar 'io.netty', 'netty-codec', '4.1.37.Final'
  require_jar 'com.fasterxml.jackson.core', 'jackson-core', '2.9.8'
end
