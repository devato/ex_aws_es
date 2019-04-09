defmodule ExAwsElasticsearchTest do
  use ExUnit.Case
  doctest ExAws.Elasticsearch

  test "create_elasticsearch_domain" do
    op = ExAws.Elasticsearch.create_elasticsearch_domain("https://your.es.domain.com")

    assert op == %ExAws.Operation.Query{
             action: :create_elasticsearch_domain,
             params: %{
               "Action" => "CreateElasticsearchDomain",
               "DomainName" => "https://your.es.domain.com",
               "Version" => "2015-01-01"
             },
             parser: &ExAws.Utils.identity/2,
             path: "/",
             service: :es
           }
  end

  test "create_elasticsearch_domain with opts" do
    opts = [
      elasticsearch_version: "2.3",
      elasticsearch_cluster_config: %{
        instance_type: "m3.medium.elasticsearch",
        instance_count: 5,
        dedicated_master_enabled: true,
        zone_awareness_enabled: true,
        zone_awareness_config: %{availability_zone_count: 3},
        dedicated_master_type: "i3.large.elasticsearch",
        dedicated_master_count: 3
      },
      ebs_options: %{
        ebs_enabled: false
      },
      vpc_options: %{
        subnet_ids: ["subnet-123", "subnet-456"],
        security_group_ids: ["sg-12345", "sg-67890"]
      }
    ]

    op = ExAws.Elasticsearch.create_elasticsearch_domain("https://your.es.domain.com", opts)

    assert op = %ExAws.Operation.Query{
             action: :create_elasticsearch_domain,
             params: %{
               "Action" => "CreateElasticsearchDomain",
               "DomainName" => "https://your.es.domain.com",
               "EbsOptions.EbsEnabled" => false,
               "ElasticsearchClusterConfig.DedicatedMasterCount" => 3,
               "ElasticsearchClusterConfig.DedicatedMasterEnabled" => true,
               "ElasticsearchClusterConfig.DedicatedMasterType" => "i3.large.elasticsearch",
               "ElasticsearchClusterConfig.InstanceCount" => 5,
               "ElasticsearchClusterConfig.InstanceType" => "m3.medium.elasticsearch",
               "ElasticsearchClusterConfig.ZoneAwarenessConfig.AvailabilityZoneCount" => 3,
               "ElasticsearchClusterConfig.ZoneAwarenessEnabled" => true,
               "ElasticsearchVersion" => "2.3",
               "Version" => "2015-01-01",
               "VpcOptions.SecurityGroupIds.1" => "sg-12345",
               "VpcOptions.SecurityGroupIds.2" => "sg-67890",
               "VpcOptions.SubnetIds.1" => "subnet-123",
               "VpcOptions.SubnetIds.2" => "subnet-456"
             },
             parser: &ExAws.Utils.identity/2,
             path: "/",
             service: :es
           }
  end

  test "update_elasticsearch_domain_config" do
    op = ExAws.Elasticsearch.update_elasticsearch_domain_config("https://your.es.domain.com")

    assert op = %ExAws.Operation.Query{
             action: :update_elasticsearch_domain_config,
             params: %{
               "Action" => "UpdateElasticsearchDomainConfig",
               "DomainName" => "https://your.es.domain.com",
               "Version" => "2015-01-01"
             },
             parser: &ExAws.Utils.identity/2,
             path: "/",
             service: :es
           }
  end

  test "update_elasticsearch_domain_config with opts" do
    opts = [
      elasticsearch_version: "2.3",
      elasticsearch_cluster_config: %{
        instance_type: "m3.medium.elasticsearch",
        instance_count: 5,
        dedicated_master_enabled: true,
        zone_awareness_enabled: true,
        zone_awareness_config: %{availability_zone_count: 3},
        dedicated_master_type: "i3.large.elasticsearch",
        dedicated_master_count: 3
      },
      ebs_options: %{
        ebs_enabled: false
      },
      vpc_options: %{
        subnet_ids: ["subnet-123", "subnet-456"],
        security_group_ids: ["sg-12345", "sg-67890"]
      }
    ]

    op =
      ExAws.Elasticsearch.update_elasticsearch_domain_config("https://your.es.domain.com", opts)

    assert op = %ExAws.Operation.Query{
             action: :update_elasticsearch_domain_config,
             params: %{
               "Action" => "UpdateElasticsearchDomainConfig",
               "DomainName" => "https://your.es.domain.com",
               "EbsOptions.EbsEnabled" => false,
               "ElasticsearchClusterConfig.DedicatedMasterCount" => 3,
               "ElasticsearchClusterConfig.DedicatedMasterEnabled" => true,
               "ElasticsearchClusterConfig.DedicatedMasterType" => "i3.large.elasticsearch",
               "ElasticsearchClusterConfig.InstanceCount" => 5,
               "ElasticsearchClusterConfig.InstanceType" => "m3.medium.elasticsearch",
               "ElasticsearchClusterConfig.ZoneAwarenessConfig.AvailabilityZoneCount" => 3,
               "ElasticsearchClusterConfig.ZoneAwarenessEnabled" => true,
               "ElasticsearchVersion" => "2.3",
               "Version" => "2015-01-01",
               "VpcOptions.SecurityGroupIds.1" => "sg-12345",
               "VpcOptions.SecurityGroupIds.2" => "sg-67890",
               "VpcOptions.SubnetIds.1" => "subnet-123",
               "VpcOptions.SubnetIds.2" => "subnet-456"
             },
             parser: &ExAws.Utils.identity/2,
             path: "/",
             service: :es
           }
  end
end
