package adrianjuhl.springboot_camel_openshift_maven_archetype_process_improvement;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

/**
 * The Rest interface of the application.
 */
@Path("/")
public interface RestInterface {

  /**
   * readinessprobe.
   *
   * @return A string, indicating that the application is ready to accept calls.
   */
  @GET
  @Path("/readinessprobe")
  @Produces({MediaType.TEXT_PLAIN})
  void readinessprobe();

}
