require 'chefspec'

describe 'http_server::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'http_server::default' }
  it 'should install nginx' do
    chef_run.should start_service 'nginx'
  end

  it 'should start nginx' do
    chef_run.should start_service 'nginx'
  end

  it 'should create virtualhost base dir' do
    dir = chef_run.node['nginx']['vhost_dir']
    chef_run.should create_directory dir
    chef_run.directory(dir).should be_owned_by('www-data', 'www-data')
    chef_run.directory(dir).mode.should == "0750"
  end


  describe 'create virtualhosts' do
    site = 'www.example.com'
    it "create vhost directory" do
      dir = ::File.join(chef_run.node['nginx']['vhost_dir'], site)
      chef_run.should create_directory dir
      chef_run.directory(dir).should be_owned_by('www-data', 'www-data')
      chef_run.directory(dir).mode.should == "0750"
    end

    it "create vhost index.html" do
      file = ::File.join(chef_run.node['nginx']['vhost_dir'], site, "index.html")
      chef_run.should create_file_with_content file, site
      chef_run.file(file).should be_owned_by('www-data', 'www-data')
      chef_run.file(file).mode.should == "0640"
    end

    it "create vhost nginx config" do
      file = ::File.join(chef_run.node['nginx']['site_avail_dir'], "#{site}.conf",)
      chef_run.template(file).should be_owned_by("root", "root")
      chef_run.template(file).mode.should == "0640"
      chef_run.template(file).should notify("service[nginx]", :restart)
      puts chef_run.template(file).inspect
    end

    it "create vhost nginx config link" do
      file = ::File.join(chef_run.node['nginx']['site_avail_dir'], "#{site}.conf")
      link = ::File.join(chef_run.node['nginx']['site_enable_dir'], "#{site}.conf")
      chef_run.should create_link link
      chef_run.link(link).to.should == file
    end
  end
end
