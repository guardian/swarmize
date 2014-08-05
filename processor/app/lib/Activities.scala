package lib

import com.amazonaws.services.simpleworkflow.model.ActivityType
import swarmize.aws.SimpleWorkflow
import swarmize.json.SubmittedData

trait Activity {
  def name: String
  def version: String

  def activityType = new ActivityType().withName(name).withVersion(version)

  def process(r: SubmittedData): SubmittedData
}

object Activity {

  val all = List[Activity](
    StoreInElasticsearchActivity
  )

  val allTypes = all map (_.activityType)

  val lookupByType = all.map(a => a.activityType -> a).toMap.withDefault(
    t => sys.error("cannot process activity type of " + t))


  def registerAll() {
    allTypes.foreach(SimpleWorkflow.createActivityIfNeeded)
  }
}
