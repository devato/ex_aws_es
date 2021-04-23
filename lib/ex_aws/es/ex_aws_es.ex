defmodule ExAws.ES do
  @moduledoc """
  Documentation for ExAwsES.
  """
  use ExAws.Utils,
    format_type: :xml,
    non_standard_keys: %{}

  # version of the AWS API
  @version "2015-01-01"

  @type tag :: %{key: binary, value: binary}
  @type tag_key_only :: %{key: binary}

  @type domain_name_opts :: [domain_name: binary]

  @type upgrade_elasticsearch_domain_opts :: [perform_check_only :: boolean]

  @type elasticsearch_cluster_config :: %{
          instance_type: binary,
          instance_count: integer,
          dedicated_master_enabled: boolean,
          zone_awareness_enabled: boolean,
          zone_awareness_config: %{availability_zone_count: integer},
          dedicated_master_type: binary,
          dedicated_master_count: integer
        }

  @type ebs_options :: %{
          ebs_enabled: boolean,
          volume_type: binary,
          volume_size: integer,
          iops: integer
        }

  @type snapshot_options :: %{
          automated_snapshot_start_hour: integer
        }

  @type advanced_options :: %{
          string: binary
        }

  @type vpc_options :: %{
          subnet_ids: [binary, ...],
          security_group_ids: [binary, ...]
        }

  @type cognito_options :: %{
          enabled: boolean,
          user_pool_id: binary,
          identity_pool_id: binary,
          role_arn: binary
        }

  @type encryption_at_rest_options :: %{
          enabled: boolean,
          kms_key_id: binary
        }

  @type log_publishing_options :: %{
          string: %{
            cloudwatchlogs_log_group_arn: binary,
            enabled: boolean
          }
        }

  @type create_elasticsearch_domain_opts :: [
          elasticsearch_version: binary,
          elasticsearch_cluster_config: elasticsearch_cluster_config,
          ebs_options: ebs_options,
          access_policies: binary,
          snapshot_options: snapshot_options,
          vpc_options: vpc_options,
          cognito_options: cognito_options,
          encryption_at_rest_options: encryption_at_rest_options,
          node_to_node_encryption_options: %{
            enabled: boolean
          },
          advanced_options: advanced_options,
          log_publishing_options: log_publishing_options
        ]

  @type describe_reserved_elasticsearch_instance_offerings_opts :: [
          reserved_elasticsearch_instance_oferring_id: binary,
          max_results: integer,
          next_token: binary
        ]

  @type describe_reserved_elasticsearch_instances_opts :: [
          reserved_elasticsearch_instance_id: binary,
          max_results: integer,
          next_token: binary
        ]

  @type paging_opts :: [
          max_results: integer,
          next_token: binary
        ]

  @type list_elasticsearch_instance_types_opts :: [
          domain_name: binary,
          max_results: integer,
          next_token: binary
        ]

  @type purchase_reserved_elasticsearch_instance_oferring_opts :: [
          instance_count: integer
        ]

  @type update_elasticsearch_domain_config_opts :: [
          elasticsearch_cluster_config: elasticsearch_cluster_config,
          ebs_options: ebs_options,
          snapshot_options: snapshot_options,
          vpc_options: vpc_options,
          cognito_options: cognito_options,
          advanced_options: advanced_options,
          access_policies: binary,
          log_publishing_options: log_publishing_options
        ]
  @doc """
  Attaches tags to an existing Elasticsearch domain.

  Tags are a set of case-sensitive key value pairs. An Elasticsearch domain may
  have up to 10 tags. See [Managing Amazon Elasticsearch Service
  Domains](https://amzn.to/2CZxBEH) for more information.

  ## Parameters:

    * arn (`String`) - Specify the ARN for which you want to add the tags.


    * tags (`List` of `t:tag/0`) - List of Tag that need to be added for the
      Elasticsearch domain.

  ## Examples:

        iex> ExAws.ES.add_tags("arn:aws:elasticsearch:region:123456789:your_es", [%{key: "Hello", value: "test"}])
        %ExAws.Operation.Query{
        action: :add_tags,
        params: %{
          "Action" => "AddTags",
          "Arn" => "arn:aws:elasticsearch:region:123456789:your_es",
          "TagList.1.Key" => "Hello",
          "TagList.1.Value" => "test",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
        }

  """
  @spec add_tags(arn :: binary, tag_list :: [tag, ...]) :: ExAws.Operation.Query.t()
  def add_tags(arn, tag_list) do
    [{:arn, arn}, {:tag_list, tag_list}]
    |> build_request(:add_tags)
  end

  @doc """
  Cancels a scheduled service software update for an Amazon ES domain.

  You can only perform this operation before the AutomatedUpdateDate and when the
  UpdateStatus is in the PENDING_UPDATE state.

  ## Parameters:

    * domain_name(`String`) - The name of the domain that you want to stop the
      latest service software update on.


  ## Examples:

      iex> ExAws.ES.cancel_elasticsearch_service_software_update("http://your.es.domain.here.com")
      %ExAws.Operation.Query{
        action: :cancel_elasticsearch_service_software_update,
        params: %{
          "Action" => "CancelElasticsearchServiceSoftwareUpdate",
          "DomainName" => "http://your.es.domain.here.com",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec cancel_elasticsearch_service_software_update(domain_name :: binary) ::
          ExAws.Operation.Query.t()
  def cancel_elasticsearch_service_software_update(domain_name) do
    [{:domain_name, domain_name}]
    |> build_request(:cancel_elasticsearch_service_software_update)
  end

  @doc """
  Creates a new Elasticsearch domain.

  For more information, see [Creating Elasticsearch Domains](https://amzn.to/2Uu3XC7)
  in the Amazon Elasticsearch Service Developer Guide.

  ## Parameters:

    * domain_name (`String`) - The name of the Elasticsearch domain that you are
      creating. Domain names are unique across the domains owned by an account
      within an AWS region. Domain names must start with a letter or number and
      can contain the following characters: a-z (lowercase), 0-9, and -
      (hyphen).

    * elasticsearch_version (`String`) - String of format X.Y to specify version
      for the Elasticsearch domain eg. "1.5" or "2.3". For more information, see
      [Creating Elasticsearch Domains](https://amzn.to/2Uu3XC7) in the Amazon
      Elasticsearch Service Developer Guide.

    * elasticsearch_cluster_config (`Map` of `t:elasticsearch_cluster_config/0`)
    - Configuration options for an Elasticsearch domain. Specifies the instance
      type and number of instances in the domain cluster.
        * instance_type (`String`) - The instance type for an Elasticsearch
        cluster.
        * instance_count (`Integer`) - The number of instances in the
        specified domain cluster.
        * dedicated_master_enabled (`Boolean`) - A
        boolean value to indicate whether a dedicated master node is enabled.
        See [About Dedicated Master Nodes](https://amzn.to/2UMAmDe)
        for more information.
        * zone_awareness_enabled (`Boolean`) - A boolean
        value to indicate whether zone awareness is enabled. See [About Zone
        Awareness](https://amzn.to/2WVHYkm) for more information.
        * zone_awareness_config (`Map`) - Specifies the
        zone awareness configuration for a domain when zone awareness is
        enabled.
            * availability_zone_count (`Integer`) - An integer value to
            indicate the number of availability zones for a domain when zone
            awareness is enabled. This should be equal to number of subnets if VPC
            endpoints is enabled
        * dedicated_master_type (`String`) - The instance
        type for a dedicated master node.
        * dedicated_master_count (`Integer`) - Total number of dedicated master nodes, active and on standby, for
        the cluster.

    * ebs_options (`Map` of `t:ebs_options/0`) - Options to enable, disable and
      specify the type and size of EBS storage volumes.
      * ebs_enabled (`Boolean`) - Specifies whether EBS-based storage is enabled.
      * volume_type (`String`) - Specifies the volume type for EBS-based
      storage.
      * volume_size (`Integer`) - Integer to specify the size of an
      EBS volume.
      * iops (`Integer`) - Specifies the IOPD for a Provisioned
      IOPS EBS volume (SSD).

    * access_policies (`String`) - IAM access policy as a JSON-formatted string.

    * snapshot_options (`Map` of `t:snapshot_options/0`) - Option to set time,
      in UTC format, of the daily automated snapshot. Default value is 0
      hours.
      * automated_snapshot_start_hour (`Integer`) - Specifies the
      time, in UTC format, when the service takes a daily automated snapshot
      of the specified Elasticsearch domain. Default value is 0 hours.

    * vpc_options (`Map` of `t:vpc_options/0`) - Options to specify the subnets
      and security groups for VPC endpoint. For more information, see
      [Creating a VPC](https://amzn.to/2U38s1C)
      in VPC Endpoints for Amazon Elasticsearch Service Domains
      * subnet_ids (`List` of `String`) - Specifies the subnets for VPC endpoint.
      * security_group_ids (`List` of `String`) - Specifies the security
      groups for VPC endpoint.

    * cognito_options (`Map` of `t:cognito_options/0`) - Options to specify the
      Cognito user and identity pools for Kibana authentication. For more
      information, see [Amazon Cognito Authentication for Kibana](https://amzn.to/2Q2YUX5).
      * enabled (`Boolean`) - Specifies the option to enable Cognito for
      Kibana authentication.
      * user_pool_id (`String`) - Specifies the
      Cognito user pool ID for Kibana authentication.
      * identity_pool_id (`String`) - Specifies the Cognito identity pool ID for Kibana
      authentication.
      * role_arn (`String`) - Specifies the role ARN that
      provides Elasticsearch permissions for accessing Cognito resources.

    * encryption_at_rest_options (`Map` of `t:encryption_at_rest_options/0`) -
      Specifies the Encryption At Rest Options.
      * enabled (`Boolean`) - Specifies the option to enable Encryption At Rest.
      * kms_key_id (`String`) - Specifies the KMS Key ID for Encryption At Rest options.

    * node_to_node_encryption_options (`Map`) - Specifies the NodeToNodeEncryptionOptions.
      * enabled (`Boolean`) - Specify true to enable node-to-node encryption.

    * advanced_options (`Map` of `t:advanced_options/0`) - Option to allow
      references to indices in an HTTP request body. Must be false when
      configuring access to individual sub-resources. By default, the value
      is true. See [Configuration Advanced Options](https://amzn.to/2LD1KPP)
      for more information.
      * %{`String`: "string"}

    * log_publishing_options (`Map` of `t:log_publishing_options/0`) - Map of
      LogType and LogPublishingOption , each containing options to publish a
      given type of Elasticsearch log.
      * 'String' (`String`) - Type of log file, it can be one of the following:
        - INDEX_SLOW_LOGS: Index slow logs contain insert requests that took more time than
        configured index query log threshold to execute.
        - SEARCH_SLOW_LOGS: Search slow logs contain search queries that took more time than
        configured search query log threshold to execute.
        - ES_APPLICATION_LOGS: Elasticsearch application logs contain information about errors and
        warnings raised during the operation of the service and can be useful for troubleshooting.
          * cloudwatchlogs_log_group_arn (`String`) - ARN of the Cloudwatch log
          group to which log needs to be published.,
          * enabled (`Boolean`) -
          Specifies whether given log publishing option is enabled or not.

  """
  @spec create_elasticsearch_domain(domain_name :: binary) :: ExAws.Operation.Query.t()
  @spec create_elasticsearch_domain(
          domain_name :: binary,
          opts :: create_elasticsearch_domain_opts
        ) :: ExAws.Operation.Query.t()
  def create_elasticsearch_domain(domain_name, opts \\ []) do
    [{:domain_name, domain_name} | opts]
    |> build_request(:create_elasticsearch_domain)
  end

  @doc """
  Permanently deletes the specified Elasticsearch domain and all of its data.

  Once a domain is deleted, it cannot be recovered.

  ## Parameters:

    * domain_name (`String`) - The name of the Elasticsearch domain that you
      want to permanently delete.

  ## Examples:

      iex> ExAws.ES.delete_elasticsearch_domain("http://your.es.domain.here.com")
      %ExAws.Operation.Query{
        action: :delete_elasticsearch_domain,
        params: %{
          "Action" => "DeleteElasticsearchDomain",
          "DomainName" => "http://your.es.domain.here.com",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec delete_elasticsearch_domain(domain_name :: binary) :: ExAws.Operation.Query.t()
  def delete_elasticsearch_domain(domain_name) do
    [{:domain_name, domain_name}]
    |> build_request(:delete_elasticsearch_domain)
  end

  @doc """
  Deletes the service-linked role that Elasticsearch Service uses to manage and
  maintain VPC domains.

  Role deletion will fail if any existing VPC domains use
  the role. You must delete any such Elasticsearch domains before deleting the
  role. See [Deleting Elasticsearch Service Role](https://amzn.to/2I8vdj2) in
  VPC Endpoints for Amazon Elasticsearch Service Domains .

  ## Parameters:

    None

  ## Examples:

      iex> ExAws.ES.delete_elasticsearch_service_role()
      %ExAws.Operation.Query{
        action: :delete_elasticsearch_service_role,
        params: %{
          "Action" => "DeleteElasticsearchServiceRole",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec delete_elasticsearch_service_role() :: ExAws.Operation.Query.t()
  def delete_elasticsearch_service_role() do
    [] |> build_request(:delete_elasticsearch_service_role)
  end

  @doc """
  Returns domain configuration information about the specified Elasticsearch
  domain, including the domain ID, domain endpoint, and domain ARN.

  ## Parameters:

    * domain_name (`String`) - The name of the Elasticsearch domain for which
      you want information.

  ## Examples:

      iex> ExAws.ES.describe_elasticsearch_domain("http://your.es.domain.here.com")
      %ExAws.Operation.Query{
        action: :describe_elasticsearch_domain,
        params: %{
          "Action" => "DescribeElasticsearchDomain",
          "DomainName" => "http://your.es.domain.here.com",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec describe_elasticsearch_domain(domain_name :: binary) :: ExAws.Operation.Query.t()
  def describe_elasticsearch_domain(domain_name) do
    [{:domain_name, domain_name}]
    |> build_request(:describe_elasticsearch_domain)
  end

  @doc """
  Provides cluster configuration information about the specified Elasticsearch
  domain, such as the state, creation date, update version, and update date for
  cluster options.

  ## Parameters:

    * domain_name (`String`) - The Elasticsearch domain that you want to get
      information about.

  ## Examples:

      iex> ExAws.ES.describe_elasticsearch_domain_config("http://your.es.domain.here.com")
      %ExAws.Operation.Query{
        action: :describe_elasticsearch_domain_config,
        params: %{
          "Action" => "DescribeElasticsearchDomainConfig",
          "DomainName" => "http://your.es.domain.here.com",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec describe_elasticsearch_domain_config(domain_name :: binary) :: ExAws.Operation.Query.t()
  def describe_elasticsearch_domain_config(domain_name) do
    [{:domain_name, domain_name}]
    |> build_request(:describe_elasticsearch_domain_config)
  end

  @doc """
  Returns domain configuration information about the specified Elasticsearch
  domains, including the domain ID, domain endpoint, and domain ARN.

  ## Parameters:

    * domain_names (`List` of `String`) - The Elasticsearch domains for which
      you want information.

  ## Examples:

      iex> ExAws.ES.describe_elasticsearch_domains(["http://your.es.domain.here.com", "http://your.next.es.domain.here.com"])
      %ExAws.Operation.Query{
        action: :describe_elasticsearch_domains,
        params: %{
          "Action" => "DescribeElasticsearchDomains",
          "DomainNames.1" => "http://your.es.domain.here.com",
          "DomainNames.2" => "http://your.next.es.domain.here.com",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec describe_elasticsearch_domains(domain_names :: [binary, ...]) :: ExAws.Operation.Query.t()
  def describe_elasticsearch_domains(domain_names) do
    [{:domain_names, domain_names}]
    |> build_request(:describe_elasticsearch_domains)
  end

  @doc """
  Describe Elasticsearch Limits for a given instance_type and
  elasticsearch_version.

  When modifying existing Domain, specify the ``
  DomainName `` to know what Limits are supported for modifying.

  ## Parameters:

    * domain_name (`String`) - DomainName represents the name of the Domain that
      we are trying to modify. This should be present only if we are querying
      for Elasticsearch `` Limits `` for existing domain.

    * instance_type (`String`) - The instance type for an Elasticsearch cluster
      for which Elasticsearch `` Limits `` are needed.

    * elasticsearch_version (`String`) - Version of Elasticsearch for which ``
      Limits `` are needed.

  ## Examples:

      iex> ExAws.ES.describe_elasticsearch_instance_type_limits("m3.medium.elasticsearch", "6.7.1")
      %ExAws.Operation.Query{
        action: :describe_elasticsearch_instance_type_limits,
        params: %{
          "Action" => "DescribeElasticsearchInstanceTypeLimits",
          "ElasticsearchVersion" => "6.7.1",
          "InstanceType" => "m3.medium.elasticsearch",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec describe_elasticsearch_instance_type_limits(
          instance_type :: binary,
          elasticsearch_version :: binary
        ) :: ExAws.Operation.Query.t()
  @spec describe_elasticsearch_instance_type_limits(
          instance_type :: binary,
          elasticsearch_version :: binary,
          opts :: domain_name_opts
        ) :: ExAws.Operation.Query.t()
  def describe_elasticsearch_instance_type_limits(
        instance_type,
        elasticsearch_version,
        opts \\ []
      ) do
    [{:instance_type, instance_type}, {:elasticsearch_version, elasticsearch_version} | opts]
    |> build_request(:describe_elasticsearch_instance_type_limits)
  end

  @doc """
  Lists available reserved Elasticsearch instance offerings.

  ## Parameters:

    * reserved_elasticsearch_instance_offering_id (`String`) - The offering
      identifier filter value. Use this parameter to show only the available
      offering that matches the specified reservation identifier.

    * max_results (`Integer`) - Set this value to limit the number of results
      returned. If not specified, defaults to 100.

    * next_token (`String`) - NextToken should be sent in case if earlier API
      call produced result containing NextToken. It is used for pagination.

  ## Examples:

      iex> ExAws.ES.describe_reserved_elasticsearch_instance_offerings(reserved_elasticsearch_instance_offering_id: "offering_id")
      %ExAws.Operation.Query{
        action: :describe_reserved_elasticsearch_instance_offerings,
        params: %{
          "Action" => "DescribeReservedElasticsearchInstanceOfferings",
          "ReservedElasticsearchInstanceOfferingId" => "offering_id",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec describe_reserved_elasticsearch_instance_offerings(
          opts :: describe_reserved_elasticsearch_instance_offerings_opts
        ) :: ExAws.Operation.Query.t()
  def describe_reserved_elasticsearch_instance_offerings(opts \\ []) do
    opts
    |> build_request(:describe_reserved_elasticsearch_instance_offerings)
  end

  @doc """
  Returns information about reserved Elasticsearch instances for this account.

  ## Parameters:

    * reserved_elasticsearch_instance_id (`String`) - The reserved instance
      identifier filter value. Use this parameter to show only the reservation
      that matches the specified reserved Elasticsearch instance ID.

    * max_results (`Integer`) - Set this value to limit the number of results
      returned. If not specified, defaults to 100.

    * next_token (`String`) - NextToken should be sent in case if earlier API
      call produced result containing NextToken. It is used for pagination.

  ## Examples:

      iex> ExAws.ES.describe_reserved_elasticsearch_instances(reserved_elasticsearch_instance_id: "i-123456789")
      %ExAws.Operation.Query{
        action: :describe_reserved_instances,
        params: %{
          "Action" => "DescribeReservedInstances",
          "ReservedElasticsearchInstanceId" => "i-123456789",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec describe_reserved_elasticsearch_instances(
          opts :: describe_reserved_elasticsearch_instances_opts
        ) :: ExAws.Operation.Query.t()
  def describe_reserved_elasticsearch_instances(opts \\ []) do
    opts
    |> build_request(:describe_reserved_instances)
  end

  @doc """
  Returns a list of upgrade compatible Elastisearch versions.

  You can optionally pass a `` DomainName `` to get all upgrade compatible
  Elasticsearch versions for that specific domain.

  ## Parameters:

    * domain_name (`String`) - The name of an Elasticsearch domain. Domain names
      are unique across the domains owned by an account within an AWS region.
      Domain names start with a letter or number and can contain the following
      characters: a-z (lowercase), 0-9, and - (hyphen).

  ## Examples:

      iex> ExAws.ES.get_compatible_elasticsearch_versions(domain_name: "http://your.es.domain.here.com")
      %ExAws.Operation.Query{
        action: :get_compatible_elasticsearch_versions,
        params: %{
          "Action" => "GetCompatibleElasticsearchVersions",
          "DomainName" => "http://your.es.domain.here.com",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec get_compatible_elasticsearch_versions(opts :: domain_name_opts) ::
          ExAws.Operation.Query.t()
  def get_compatible_elasticsearch_versions(opts \\ []) do
    opts
    |> build_request(:get_compatible_elasticsearch_versions)
  end

  @doc """
  Retrieves the complete history of the last 10 upgrades that were performed on
  the domain.

  ## Parameters:

    * domain_name (`String`) - The name of an Elasticsearch domain. Domain names
      are unique across the domains owned by an account within an AWS region.
      Domain names start with a letter or number and can contain the following
      characters: a-z (lowercase), 0-9, and - (hyphen).

    * max_results (`Integer`) - Set this value to limit the number of results
      returned.

    * next_token (`String`) - Paginated APIs accepts NextToken input to returns
      next page results and provides a NextToken output in the response which
      can be used by the client to retrieve more results.

  ## Examples:

      iex> ExAws.ES.get_upgrade_history("http://your.es.domain.here.com")
      %ExAws.Operation.Query{
        action: :get_upgrade_history,
        params: %{
          "Action" => "GetUpgradeHistory",
          "DomainName" => "http://your.es.domain.here.com",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec get_upgrade_history(domain_name :: binary) :: ExAws.Operation.Query.t()
  @spec get_upgrade_history(domain_name :: binary, opts :: paging_opts) ::
          ExAws.Operation.Query.t()
  def get_upgrade_history(domain_name, opts \\ []) do
    [{:domain_name, domain_name} | opts]
    |> build_request(:get_upgrade_history)
  end

  @doc """
  Retrieves the latest status of the last upgrade or upgrade eligibility check
  that was performed on the domain.

  ## Parameters:

    * domain_name (`String`) - The name of an Elasticsearch domain. Domain names
      are unique across the domains owned by an account within an AWS region.
      Domain names start with a letter or number and can contain the following
      characters: a-z (lowercase), 0-9, and - (hyphen).

  ## Examples:

      iex> ExAws.ES.get_upgrade_status("http://your.es.domain.here.com")
      %ExAws.Operation.Query{
        action: :get_upgrade_status,
        params: %{
          "Action" => "GetUpgradeStatus",
          "DomainName" => "http://your.es.domain.here.com",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec get_upgrade_status(domain_name :: binary) :: ExAws.Operation.Query.t()
  def get_upgrade_status(domain_name) do
    [{:domain_name, domain_name}]
    |> build_request(:get_upgrade_status)
  end

  @doc """
  Returns the name of all Elasticsearch domains owned by the current user's
  account.

  ## Parameters:

    None

  ## Examples:

      iex> ExAws.ES.list_domain_names()
      %ExAws.Operation.Query{
        action: :list_domain_names,
        params: %{"Action" => "ListDomainNames", "Version" => "2015-01-01"},
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec list_domain_names() :: ExAws.Operation.Query.t()
  def list_domain_names() do
    [] |> build_request(:list_domain_names)
  end

  @doc """
  List all Elasticsearch instance types that are supported for given
  ElasticsearchVersion

  ## Parameters:

    * elasticsearch_version (`String`) - Version of Elasticsearch for which list
      of supported elasticsearch instance types are needed.

    * domain_name (`String`) - DomainName represents the name of the Domain that
      we are trying to modify. This should be present only if we are querying
      for list of available Elasticsearch instance types when modifying existing
      domain.

    * max_results (`Integer`) - Set this value to limit the number of results
      returned. Value provided must be greater than 30 else it wont be honored.

    * next_token (`String`) - NextToken should be sent in case if earlier API
      call produced result containing NextToken. It is used for pagination.

  ## Examples:

      iex> ExAws.ES.list_elasticsearch_instance_types("6.7.1")
      %ExAws.Operation.Query{
        action: :list_elasticsearch_instance_types,
        params: %{
          "Action" => "ListElasticsearchInstanceTypes",
          "ElasticsearchVersion" => "6.7.1",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec list_elasticsearch_instance_types(elasticsearch_version :: binary) ::
          ExAws.Operation.Query.t()
  @spec list_elasticsearch_instance_types(
          elasticsearch_version :: binary,
          opts :: list_elasticsearch_instance_types_opts
        ) :: ExAws.Operation.Query.t()
  def list_elasticsearch_instance_types(elasticsearch_version, opts \\ []) do
    [{:elasticsearch_version, elasticsearch_version} | opts]
    |> build_request(:list_elasticsearch_instance_types)
  end

  @doc """
  List all supported Elasticsearch versions

  ## Parameters:

    * max_results (`Integer`) - Set this value to limit the number of results
      returned. Value provided must be greater than 10 else it wont be honored.

    * next_token (`String`) - Paginated APIs accepts NextToken input to returns
      next page results and provides a NextToken output in the response which
      can be used by the client to retrieve more results.

  ## Examples:

      iex> ExAws.ES.list_elasticsearch_versions(max_results: 20)
      %ExAws.Operation.Query{
        action: :list_elasticsearch_versions,
        params: %{
          "Action" => "ListElasticsearchVersions",
          "MaxResults" => 20,
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec list_elasticsearch_versions() :: ExAws.Operation.Query.t()
  @spec list_elasticsearch_versions(opts :: paging_opts) :: ExAws.Operation.Query.t()
  def list_elasticsearch_versions(opts \\ []) do
    opts
    |> build_request(:list_elasticsearch_versions)
  end

  @doc """
  Returns all tags for the given Elasticsearch domain.

  ## Parameters:

    * arn (`String`) - Specify the ARN for the Elasticsearch domain to which the
      tags are attached that you want to view.

  ## Examples:

      iex> ExAws.ES.list_tags("arn:aws:elasticsearch:region:123456789:your_es")
      %ExAws.Operation.Query{
        action: :list_tags,
        params: %{
          "Action" => "ListTags",
          "Arn" => "arn:aws:elasticsearch:region:123456789:your_es",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec list_tags(arn :: binary) :: ExAws.Operation.Query.t()
  def list_tags(arn) do
    [{:arn, arn}]
    |> build_request(:list_tags)
  end

  @doc """
  Allows you to purchase reserved Elasticsearch instances.

  ## Parameters:

    * reserved_elasticsearch_instance_offering_id (`String`) - The ID of the
      reserved Elasticsearch instance offering to purchase.

    * reservation_name (`String`) - A customer-specified identifier to track
      this reservation.

    * instance_count (`Integer`) - The number of Elasticsearch instances to
      reserve.

  ## Examples:

      iex> ExAws.ES.purchase_reserved_elasticsearch_instance_offering("offering_id", "reservation_name", instance_count: 10)
      %ExAws.Operation.Query{
        action: :purchase_reserved_elasticsearch_instance_offering,
        params: %{
          "Action" => "PurchaseReservedElasticsearchInstanceOffering",
          "InstanceCount" => 10,
          "ReservationName" => "reservation_name",
          "ReservedElasticsearchInstanceOfferingId" => "offering_id",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec purchase_reserved_elasticsearch_instance_offering(
          reserved_elasticsearch_instance_offering_id :: binary,
          reservation_name :: binary
        ) :: ExAws.Operation.Query.t()
  @spec purchase_reserved_elasticsearch_instance_offering(
          reserved_elasticsearch_instance_offering_id :: binary,
          reservation_name :: binary,
          opts :: purchase_reserved_elasticsearch_instance_oferring_opts
        ) :: ExAws.Operation.Query.t()
  def purchase_reserved_elasticsearch_instance_offering(
        reserved_elasticsearch_instance_offering_id,
        reservation_name,
        opts \\ []
      ) do
    [
      {:reserved_elasticsearch_instance_offering_id, reserved_elasticsearch_instance_offering_id},
      {:reservation_name, reservation_name} | opts
    ]
    |> build_request(:purchase_reserved_elasticsearch_instance_offering)
  end

  @doc """
  Removes the specified set of tags from the specified Elasticsearch domain.

  ## Parameters:

    * arn (`String`) - Specifies the ARN for the Elasticsearch domain from which
      you want to delete the specified tags.

    * tag_keys (`List` of `t:tag_key_only/0`) - Specifies the TagKey list which
      you want to remove from the Elasticsearch domain.

  ## Examples:

      iex> ExAws.ES.remove_tags("arn:aws:elasticsearch:region:123456789:your_es", [%{key: "Hello"}, %{key: "World"}])
      %ExAws.Operation.Query{
        action: :remove_tags,
        params: %{
          "Action" => "RemoveTags",
          "Arn" => "arn:aws:elasticsearch:region:123456789:your_es",
          "TagKeys.1.Key" => "Hello",
          "TagKeys.2.Key" => "World",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec remove_tags(arn :: binary, tag_keys :: [tag_key_only, ...]) :: ExAws.Operation.Query.t()
  def remove_tags(arn, tag_keys) do
    [{:arn, arn}, {:tag_keys, tag_keys}]
    |> build_request(:remove_tags)
  end

  @doc """
  Schedules a service software update for an Amazon ES domain.

  ## Parameters:

    * domain_name (`String`) - The name of the domain that you want to update to
      the latest service software.

  ## Examples:

      iex> ExAws.ES.start_elasticsearch_service_software_update("http://your.es.domain.here.com")
      %ExAws.Operation.Query{
        action: :start_elasticsearch_service_software_update,
        params: %{
          "Action" => "StartElasticsearchServiceSoftwareUpdate",
          "DomainName" => "http://your.es.domain.here.com",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec start_elasticsearch_service_software_update(domain_name :: binary) ::
          ExAws.Operation.Query.t()
  def start_elasticsearch_service_software_update(domain_name) do
    [{:domain_name, domain_name}]
    |> build_request(:start_elasticsearch_service_software_update)
  end

  @doc """
  Modifies the cluster configuration of the specified Elasticsearch domain, setting as setting the instance type and the number of instances.

  ## Parameters:

    * domain_name (`String`) - The name of the Elasticsearch domain that you are
      creating. Domain names are unique across the domains owned by an account
      within an AWS region. Domain names must start with a letter or number and
      can contain the following characters: a-z (lowercase), 0-9, and -
      (hyphen).

    * elasticsearch_cluster_config (`Map` of `t:elasticsearch_cluster_config/0`)
      - Configuration options for an Elasticsearch domain. Specifies the
      instance type and number of instances in the domain cluster.
      * instance_type (`String`) - The instance type for an Elasticsearch
      cluster.
      * instance_count (`Integer`) - The number of instances in the
      specified domain cluster.
      * dedicated_master_enabled (`Boolean`) - A
      boolean value to indicate whether a dedicated master node is enabled.
      See [About Dedicated Master Nodes](https://amzn.to/2UMAmDe)
      for more information.
      * zone_awareness_enabled (`Boolean`) - A boolean
      value to indicate whether zone awareness is enabled. See [About Zone
      Awareness](https://amzn.to/2WVHYkm) for more information.
      * zone_awareness_config (`Map`) - Specifies the
      zone awareness configuration for a domain when zone awareness is
      enabled.
        * availability_zone_count (`Integer`) - An integer value to
        indicate the number of availability zones for a domain when zone
        awareness is enabled. This should be equal to number of subnets if VPC
        endpoints is enabled
      * dedicated_master_type (`String`) - The instance
      type for a dedicated master node.
      * dedicated_master_count (`Integer`) - Total number of dedicated master nodes, active and on standby, for
      the cluster.

    * ebs_options (`Map` of `t:ebs_options/0`) - Options to enable, disable and
      specify the type and size of EBS storage volumes.
      * ebs_enabled (`Boolean`) - Specifies whether EBS-based storage is enabled.
      * volume_type (`String`) - Specifies the volume type for EBS-based
      storage.
      * volume_size (`Integer`) - Integer to specify the size of an
      EBS volume.
      * iops (`Integer`) - Specifies the IOPD for a Provisioned
      IOPS EBS volume (SSD).

    * access_policies (`String`) - IAM access policy as a JSON-formatted string.

    * snapshot_options (`Map` of `t:snapshot_options/0`) - Option to set time,
      in UTC format, of the daily automated snapshot. Default value is 0
      hours.
      * automated_snapshot_start_hour (`Integer`) - Specifies the
      time, in UTC format, when the service takes a daily automated snapshot
      of the specified Elasticsearch domain. Default value is 0 hours.

    * vpc_options (`Map` of `t:vpc_options/0`) - Options to specify the subnets
      and security groups for VPC endpoint. For more information, see
      [Creating a VPC](https://amzn.to/2U38s1C)
      in VPC Endpoints for Amazon Elasticsearch Service Domains
      * subnet_ids (`List` of `String`) - Specifies the subnets for VPC endpoint.
      * security_group_ids (`List` of `String`) - Specifies the security
      groups for VPC endpoint.

    * cognito_options (`Map` of `t:cognito_options/0`) - Options to specify the
      Cognito user and identity pools for Kibana authentication. For more
      information, see [Amazon Cognito Authentication for Kibana](https://amzn.to/2Q2YUX5).
      * enabled (`Boolean`) - Specifies the option to enable Cognito for
      Kibana authentication.
      * user_pool_id (`String`) - Specifies the
      Cognito user pool ID for Kibana authentication.
      * identity_pool_id (`String`) - Specifies the Cognito identity pool ID for Kibana
      authentication.
      * role_arn (`String`) - Specifies the role ARN that
      provides Elasticsearch permissions for accessing Cognito resources.

    * advanced_options (`Map` of `t:advanced_options/0`) - Option to allow
      references to indices in an HTTP request body. Must be false when
      configuring access to individual sub-resources. By default, the value
      is true. See [Configuration Advanced Options](https://amzn.to/2LD1KPP)
      for more information.
      * %{`String`: "string"}

    * log_publishing_options (`Map` of `t:log_publishing_options/0`) - Map of
      LogType and LogPublishingOption , each containing options to publish a
      given type of Elasticsearch log.
      * 'String' (`String`) - Type of log file, it can be one of the following:
        - INDEX_SLOW_LOGS: Index slow logs contain insert requests that took more time than
        configured index query log threshold to execute.
        - SEARCH_SLOW_LOGS: Search slow logs contain search queries that took more time than
        configured search query log threshold to execute.
        - ES_APPLICATION_LOGS: Elasticsearch application logs contain information about errors and
        warnings raised during the operation of the service and can be useful for troubleshooting.
          * cloudwatchlogs_log_group_arn (`String`) - ARN of the Cloudwatch log
          group to which log needs to be published.,
          * enabled (`Boolean`) -
          Specifies whether given log publishing option is enabled or not.

  """
  @spec update_elasticsearch_domain_config(domain_name :: binary) :: ExAws.Operation.Query.t()
  @spec update_elasticsearch_domain_config(
          domain_name :: binary,
          opts :: update_elasticsearch_domain_config_opts
        ) :: ExAws.Operation.Query.t()
  def update_elasticsearch_domain_config(domain_name, opts \\ []) do
    [{:domain_name, domain_name} | opts]
    |> build_request(:update_elasticsearch_domain_config)
  end

  @doc """
  Allows you to either upgrade your domain or perform an Upgrade eligibility
  check to a compatible Elasticsearch version.

  ## Parameters:

    * domain_name (`String`) - The name of an Elasticsearch domain. Domain names
      are unique across the domains owned by an account within an AWS region.
      Domain names start with a letter or number and can contain the following
      characters: a-z (lowercase), 0-9, and - (hyphen).

    * target_version (`String`) - The version of Elasticsearch that you intend
      to upgrade the domain to.

    * perform_check_only (`Boolean`) - This flag, when set to True, indicates
      that an Upgrade Eligibility Check needs to be performed. This will not
      actually perform the Upgrade.

  ## Examples:

      iex> ExAws.ES.upgrade_elasticsearch_domain("http://your.es.domain.here.com", "6.7.1", perform_check_only: true)
      %ExAws.Operation.Query{
        action: :upgrade_elasticsearch_domain,
        params: %{
          "Action" => "UpgradeElasticsearchDomain",
          "DomainName" => "http://your.es.domain.here.com",
          "PerformCheckOnly" => true,
          "TargetVersion" => "6.7.1",
          "Version" => "2015-01-01"
        },
        parser: &ExAws.Utils.identity/2,
        path: "/",
        service: :es
      }

  """
  @spec upgrade_elasticsearch_domain(domain_name :: binary, target_version :: binary) ::
          ExAws.Operation.Query.t()
  @spec upgrade_elasticsearch_domain(
          domain_name :: binary,
          target_version :: binary,
          opts :: upgrade_elasticsearch_domain_opts
        ) :: ExAws.Operation.Query.t()
  def upgrade_elasticsearch_domain(domain_name, target_version, opts \\ []) do
    [{:domain_name, domain_name}, {:target_version, target_version} | opts]
    |> build_request(:upgrade_elasticsearch_domain)
  end

  ####################
  # Helper Functions #
  ####################

  defp build_request(opts, action) do
    opts
    |> Enum.flat_map(&format_param/1)
    |> request(action)
  end

  defp format_param({key, parameters}) do
    format([{key, parameters}])
  end

  defp request(params, action) do
    action_string = action |> Atom.to_string() |> Macro.camelize()

    %ExAws.Operation.Query{
      path: "/",
      params:
        params
        |> filter_nil_params
        |> Map.put("Action", action_string)
        |> Map.put("Version", @version),
      service: :es,
      action: action
    }
  end
end
