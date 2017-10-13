class ClusterProvisionWorker
  include Sidekiq::Worker
  include ClusterQueue

  def perform(cluster_id)
    Clusters::Cluster.find_by_id(cluster_id).try do |cluster|
      cluster.gcp_provider.try do |provider|
        Clusters::Gcp::ProvisionService.new.execute(provider)
      end
    end
  end
end
