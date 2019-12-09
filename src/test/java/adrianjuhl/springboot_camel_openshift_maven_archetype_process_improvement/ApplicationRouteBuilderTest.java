/*
 * A single test can be run in this way:
 * mvn -Dtest=ApplicationRouteBuilderTest#readinessprobeRouteShouldRespondWithReadyMessage clean test
 */
package adrianjuhl.springboot_camel_openshift_maven_archetype_process_improvement;

import java.util.List;
import java.util.Map;

import org.apache.camel.CamelContext;
import org.apache.camel.Exchange;
import org.apache.camel.ProducerTemplate;
import org.apache.camel.builder.AdviceWithRouteBuilder;
import org.apache.camel.component.mock.MockEndpoint;
import org.apache.camel.test.spring.CamelSpringBootRunner;
import org.apache.camel.test.spring.UseAdviceWith;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.DirtiesContext;

@RunWith(CamelSpringBootRunner.class)
@UseAdviceWith
@SpringBootTest(classes=Application.class)
@DirtiesContext(classMode=DirtiesContext.ClassMode.AFTER_EACH_TEST_METHOD)
public class ApplicationRouteBuilderTest {

  @Autowired
  private CamelContext context;

  @Autowired
  private ProducerTemplate template;

  /**
   * The readinessprobe endpoint should return "ready".
   *
   * @throws Exception
   */
  @Test
  public void readinessprobeRouteShouldRespondWithReadyMessage() throws Exception {
    MockEndpoint mockOut = getMockEndpoint("mock:out");
    context
      .getRouteDefinition(RouteInfo.READINESS_PROBE.id())
      .adviceWith(context, new AdviceWithRouteBuilder() {
        @Override
        public void configure() throws Exception {
          weaveAddLast().to("mock:out");
        }
      });
    context.start();
    mockOut.expectedBodiesReceived("ready");
    template.sendBody(RouteInfo.READINESS_PROBE.uri(), null);
    debugExchanges(mockOut);
    mockOut.assertIsSatisfied();
  }

  private MockEndpoint getMockEndpoint(String uri) {
    return context.getEndpoint(uri, MockEndpoint.class);
  }

  private void debugExchanges(MockEndpoint mockEndpoint) {
    List<Exchange> exchangesReceived = mockEndpoint.getExchanges();
    for(Exchange exchange : exchangesReceived) {
      Object body = exchange.getIn().getBody();
      Map<String,Object> inHeaders = exchange.getIn().getHeaders();
      System.out.println("exchange: " + exchange);
      System.out.println("exchange body (class " + body.getClass() + "): " + body);
      System.out.println("exchange in headers: " + inHeaders);
    }
  }

}
