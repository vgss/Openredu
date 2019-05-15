# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MyfileService do
  context "creating file" do
    let(:file) do
      File.open("#{Rails.root}/spec/fixtures/api/pdf_example.pdf")
    end
    let(:model_attrs) { { :attachment => file } }
    subject do
      MyfileService.new(params)
    end

    context "#create" do

      it "should create a Myfile" do
        expect {
          subject.create
        }.to change(Myfile, :count).by(1)
      end

      it "should accept a block" do
        myfile = subject.create do |myfile|
          myfile.user = FactoryGirl.create(:user)
        end

        myfile.user.should_not be_nil
      end
    end


    context "#build" do
      it "should instanciate MyFile" do
        model = mock_model('Myfile')
        subject.stub(:model_class).and_return(model)

        model.should_receive(:new).with(model_attrs)

        subject.build
      end

      it "should yield to Myfile.new" do
        expect { |b| subject.build(&b) }.
          to yield_with_args(an_instance_of(Myfile))
      end
    end

    describe "#destroy" do
      let!(:myfile) { FactoryGirl.create(:myfile) }
      subject { MyfileService.new(params.merge(:model => myfile)) }

      it "should destroy Myfile" do
        expect {
          subject.destroy
        }.to change(Myfile, :count).by(-1)
      end

      it "should return the myfile instance" do
        subject.destroy.should == myfile
      end
    end
  end
end
