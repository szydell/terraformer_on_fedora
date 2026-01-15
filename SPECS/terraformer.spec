%global debug_package %{nil}
%global provider        github
%global provider_tld    com
%global project         GoogleCloudPlatform
%global repo            terraformer
%global import_path     %{provider}.%{provider_tld}/%{project}/%{repo}

Name:           terraformer
Version:        0.8.30
Release:        5%{?dist}
Summary:        CLI tool to generate terraform files from existing infrastructure
License:        Apache-2.0
URL:            https://%{import_path}
Source0:        https://%{import_path}/archive/refs/tags/%{version}.tar.gz

BuildRequires:  golang >= 1.25
BuildRequires:  git

%description
A CLI tool that generates tf/json and tfstate files based on existing 
infrastructure (reverse Terraform). Supports multiple cloud providers 
including AWS, GCP, Azure, Kubernetes, and more.

%prep
%setup -q -n %{repo}-%{version}

%build
export GO111MODULE=on
export CGO_ENABLED=0

go build -v -a \
    -ldflags "-X main.version=%{version}" \
    -o %{name} .

%install
install -d %{buildroot}%{_bindir}
install -p -m 0755 %{name} %{buildroot}%{_bindir}/%{name}

%files
%license LICENSE
%doc README.md
%{_bindir}/%{name}

%changelog
