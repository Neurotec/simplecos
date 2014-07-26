require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe SipProfilesController do

  # This should return the minimal set of attributes required to create a valid
  # SipProfile. As you add validations to SipProfile, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "name" => "MyString" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SipProfilesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all sip_profiles as @sip_profiles" do
      sip_profile = SipProfile.create! valid_attributes
      get :index, {}, valid_session
      assigns(:sip_profiles).should eq([sip_profile])
    end
  end

  describe "GET show" do
    it "assigns the requested sip_profile as @sip_profile" do
      sip_profile = SipProfile.create! valid_attributes
      get :show, {:id => sip_profile.to_param}, valid_session
      assigns(:sip_profile).should eq(sip_profile)
    end
  end

  describe "GET new" do
    it "assigns a new sip_profile as @sip_profile" do
      get :new, {}, valid_session
      assigns(:sip_profile).should be_a_new(SipProfile)
    end
  end

  describe "GET edit" do
    it "assigns the requested sip_profile as @sip_profile" do
      sip_profile = SipProfile.create! valid_attributes
      get :edit, {:id => sip_profile.to_param}, valid_session
      assigns(:sip_profile).should eq(sip_profile)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new SipProfile" do
        expect {
          post :create, {:sip_profile => valid_attributes}, valid_session
        }.to change(SipProfile, :count).by(1)
      end

      it "assigns a newly created sip_profile as @sip_profile" do
        post :create, {:sip_profile => valid_attributes}, valid_session
        assigns(:sip_profile).should be_a(SipProfile)
        assigns(:sip_profile).should be_persisted
      end

      it "redirects to the created sip_profile" do
        post :create, {:sip_profile => valid_attributes}, valid_session
        response.should redirect_to(SipProfile.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved sip_profile as @sip_profile" do
        # Trigger the behavior that occurs when invalid params are submitted
        SipProfile.any_instance.stub(:save).and_return(false)
        post :create, {:sip_profile => { "name" => "invalid value" }}, valid_session
        assigns(:sip_profile).should be_a_new(SipProfile)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        SipProfile.any_instance.stub(:save).and_return(false)
        post :create, {:sip_profile => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested sip_profile" do
        sip_profile = SipProfile.create! valid_attributes
        # Assuming there are no other sip_profiles in the database, this
        # specifies that the SipProfile created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        SipProfile.any_instance.should_receive(:update_attributes).with({ "name" => "MyString" })
        put :update, {:id => sip_profile.to_param, :sip_profile => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested sip_profile as @sip_profile" do
        sip_profile = SipProfile.create! valid_attributes
        put :update, {:id => sip_profile.to_param, :sip_profile => valid_attributes}, valid_session
        assigns(:sip_profile).should eq(sip_profile)
      end

      it "redirects to the sip_profile" do
        sip_profile = SipProfile.create! valid_attributes
        put :update, {:id => sip_profile.to_param, :sip_profile => valid_attributes}, valid_session
        response.should redirect_to(sip_profile)
      end
    end

    describe "with invalid params" do
      it "assigns the sip_profile as @sip_profile" do
        sip_profile = SipProfile.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        SipProfile.any_instance.stub(:save).and_return(false)
        put :update, {:id => sip_profile.to_param, :sip_profile => { "name" => "invalid value" }}, valid_session
        assigns(:sip_profile).should eq(sip_profile)
      end

      it "re-renders the 'edit' template" do
        sip_profile = SipProfile.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        SipProfile.any_instance.stub(:save).and_return(false)
        put :update, {:id => sip_profile.to_param, :sip_profile => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested sip_profile" do
      sip_profile = SipProfile.create! valid_attributes
      expect {
        delete :destroy, {:id => sip_profile.to_param}, valid_session
      }.to change(SipProfile, :count).by(-1)
    end

    it "redirects to the sip_profiles list" do
      sip_profile = SipProfile.create! valid_attributes
      delete :destroy, {:id => sip_profile.to_param}, valid_session
      response.should redirect_to(sip_profiles_url)
    end
  end

end
