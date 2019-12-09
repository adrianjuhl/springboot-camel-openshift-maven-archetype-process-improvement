# springboot-camel-openshift-maven-archetype-process-improvement

A project that helps with the improvements to springboot-camel-openshift-maven-archetype.

## Running the application

Run with spring-boot:run

```
$ mvn spring-boot:run -DSPRING_APPLICATION_JSON='{"cxf.path":"/api","logging.level.adrianjuhl":"DEBUG"}'
```

... or package and run (use current project version in jar name)

```
$ mvn clean package
$ java -DSPRING_APPLICATION_JSON='{"cxf.path":"/api","logging.level.adrianjuhl":"DEBUG"}' -jar target/springboot-camel-openshift-maven-archetype-process-improvement-<version>.jar
```

## Verify

Verify locally

```
$ curl http://127.0.0.1:8080/api/readinessprobe
```

# License

MIT

# Author

[Adrian Juhl](http://github.com/adrianjuhl)

# Source Code

[https://github.com/adrianjuhl/springboot-camel-openshift-maven-archetype-process-improvement](https://github.com/adrianjuhl/springboot-camel-openshift-maven-archetype-process-improvement)
