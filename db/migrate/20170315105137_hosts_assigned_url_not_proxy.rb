class HostsAssignedUrlNotProxy < ActiveRecord::Migration
  def up
    add_column :katello_content_facets, :content_source_url_id, :integer
    add_foreign_key :katello_content_facets, :smart_proxy_urls, :name => "katello_content_facets_content_source_url_id_fk", :column => "content_source_url_id"
    Host.unscoped.each do |host|
      if host.content_facet.read_attribute(:content_source_id)
        host.content_facet.content_source_url_id = SmartProxyUrl.unscoped.where(:smart_proxy_id => host.content_facet.read_attribute(:content_source_id), :primary => true).first.id
      end
      host.save
    end
    remove_foreign_key :katello_content_facets, :name => "katello_content_facets_content_source_id_fk"
    remove_column :katello_content_facets, :content_source_id, :integer

    add_column :hostgroups, :content_source_url_id, :integer
    add_foreign_key :hostgroups, :smart_proxy_urls, :name => "hostgroups_content_source_url_id_fk", :column => "content_source_url_id"
    Hostgroup.unscoped.each do |group|
      if group.read_attribute(:content_source_id)
        group.content_source_url_id = SmartProxyUrl.unscoped.where(:smart_proxy_id => group.read_attribute(:content_source_id), :primary => true).first.id
      end
      host.save
    end
    remove_foreign_key :hostgroups, :name => "hostgroups_content_source_id_fk"
    remove_column :hostgroups, :content_source_id, :integer
  end

  def down
    add_column :katello_content_facets, :content_source_id, :integer
    add_foreign_key :katello_content_facets, :smart_proxies, :name => "katello_content_facets_content_source_id_fk", :column => "content_source_id"
    Host.unscoped.each do |host|
      if host.content_facet.content_source_url_id
        host.content_facet.content_source_id = SmartProxyUrl.unscoped.where(:id => host.content_facet.content_source_url_id).first.smart_proxy_id
      end
      host.save(:validate => false)
    end
    remove_foreign_key :katello_content_facets, :name => "katello_content_facets_content_source_url_id_fk"
    remove_column :katello_content_facets, :content_source_url_id, :integer

    add_column :hostgroups, :content_source_id, :integer
    add_foreign_key :hostgroups, :smart_proxies, :name => "hostgroups_content_source_id_fk", :column => "content_source_id"
    Hostgroup.unscoped.each do |group|
      if group.content_source_url_id
        group.content_source_id = SmartProxyUrl.unscoped.where(:id => group.content_source_url_id).first.smart_proxy_id
      end
      group.save(:validate => false)
    end
    remove_foreign_key :hostgroups, :name => "hostgroups_content_source_url_id_fk"
    remove_column :hostgroups, :content_source_url_id, :integer
  end
end
