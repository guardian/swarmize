package swarmize.aws.swf

import com.amazonaws.AmazonWebServiceRequest
import com.amazonaws.handlers.AsyncHandler
import com.amazonaws.services.simpleworkflow.AmazonSimpleWorkflowAsync
import com.amazonaws.services.simpleworkflow.model._

import scala.concurrent.{Future, Promise}

object SwfAsyncHelpers {

  class AsyncHandlerToFuture[REQUEST <: AmazonWebServiceRequest, RESULT] extends AsyncHandler[REQUEST, RESULT] {
    val promise = Promise[RESULT]()

    def future = promise.future

    override def onError(exception: Exception): Unit = promise.failure(exception)

    override def onSuccess(request: REQUEST, result: RESULT): Unit = promise.success(result)
  }


  implicit class SwfAsync(swf: AmazonSimpleWorkflowAsync) {

    private def invoke[REQUEST <: AmazonWebServiceRequest, RESULT]
    (
      method: (REQUEST, AsyncHandler[REQUEST, RESULT]) => java.util.concurrent.Future[RESULT],
      req: REQUEST
    ): Future[RESULT] = {
      val handler = new AsyncHandlerToFuture[REQUEST, RESULT]
      method(req, handler)
      handler.future
    }

    // ignore the red in IntelliJ here, the scala compiler understands this :)
    def pollForDecisionTaskFuture(req: PollForDecisionTaskRequest): Future[DecisionTask] =
      invoke(swf.pollForDecisionTaskAsync, req)

    def respondDecisionTaskCompletedFuture(req: RespondDecisionTaskCompletedRequest): Future[Void] =
      invoke(swf.respondDecisionTaskCompletedAsync, req)

    def pollForActivityTaskFuture(req: PollForActivityTaskRequest): Future[ActivityTask] =
      invoke(swf.pollForActivityTaskAsync, req)
  }

}