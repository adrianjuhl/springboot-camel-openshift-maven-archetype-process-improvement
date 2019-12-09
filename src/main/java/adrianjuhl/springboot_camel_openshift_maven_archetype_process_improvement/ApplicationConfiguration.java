package adrianjuhl.springboot_camel_openshift_maven_archetype_process_improvement;

import org.apache.camel.component.cxf.jaxrs.CxfRsEndpoint;
import org.apache.cxf.Bus;
import org.apache.cxf.jaxrs.JAXRSServerFactoryBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Application configuration.
 */
@Configuration
public class ApplicationConfiguration {

  /**
   * CXF Bus.
   */
  @Autowired
  private Bus bus;

  /**
   * REST Local Service.
   *
   * @return the CXFRS rest server bean.
   */
  @Bean
  JAXRSServerFactoryBean restServer() {
    CxfRsEndpoint endpoint = new CxfRsEndpoint();
    JAXRSServerFactoryBean rsServer = endpoint.createJAXRSServerFactoryBean();
    rsServer.setBus(bus);
    rsServer.setServiceClass(RestInterface.class);
    return rsServer;
  }

}
