#
# Experiment_spec.rb
#
# Time-stamp: <2016-04-03 20:48:59 (ryosuke)>
require('spec_helper')

require('Experiment')

#---------------------------------------
describe NoParent do
  #---
  context "the default value of an instance" do
    let(:an_inst) { NoParent.new }
    subject{ an_inst.value }
    it{ is_expected.to eq '1' }
  end
  #---
  context "MyConst" do
    subject{ NoParent::MyConst }
    it{ is_expected.to be_kind_of NoParent }
    it{ expect(subject.methods).to include(:mymethod) }
    it{ expect(subject.mymethod).to eq 'a' }
    # it{ expect(subject.value).to eq '1' }
  end
end
#---------------------------------------
#---------------------------------------
describe SonOfString do
  #---
  context "the default value of an instance" do
    let(:an_inst) { SonOfString.new }
    subject{ an_inst.value }
    it{ is_expected.to eq '1' }
  end
  #---
  context "MyConst" do
    subject{ SonOfString::MyConst }
    it{ is_expected.to be_kind_of SonOfString }
    it{ expect(subject.methods).to include(:mymethod) }
    it{ expect(subject.mymethod).to eq 'a' }
    it{ expect(subject).to eq '1' }
    # it{ expect(subject.value).to eq '1' }
  end
end
#---------------------------------------
#---------------------------------------
describe IncludingMyModule do
  #---
  context "the default value of an instance" do
    let(:an_inst) { IncludingMyModule.new }
    subject{ an_inst.value }
    it{ is_expected.to eq '1' }
  end
  #---
  context "MyConst" do
    subject{ IncludingMyModule::MyConst }
    it{ is_expected.to be_kind_of IncludingMyModule }
    it{ expect(subject.methods).to include(:mymethod) }
    it{ expect(subject.mymethod).to eq 'a' }
    it{ expect(subject.value).to eq '1' }
  end
end
#---------------------------------------
#End of File
