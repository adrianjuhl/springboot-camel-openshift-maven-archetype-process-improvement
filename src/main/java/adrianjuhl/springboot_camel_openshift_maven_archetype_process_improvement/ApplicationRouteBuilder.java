package adrianjuhl.springboot_camel_openshift_maven_archetype_process_improvement;

import org.apache.camel.builder.RouteBuilder;
import org.springframework.stereotype.Component;

/**
 * The RouteBuilder of the application.
 */
@Component
public class ApplicationRouteBuilder extends RouteBuilder {

  /**
   * The routes.
   */
  @Override
  public void configure() throws Exception {

    from("cxfrs:bean:restServer?bindingStyle=SimpleConsumer")
      .recipientList(simple("direct:${header.operationName}"));

    from(RouteInfo.READINESS_PROBE.uri())
      .routeId(RouteInfo.READINESS_PROBE.id())
      .setBody(constant("ready"));

  }

}
