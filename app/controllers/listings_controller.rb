class ListingsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
   #Route '/all' listings#index
  # GET /listings
  # GET /listings.json

def landingpage
    if user_signed_in?
        @user = User.find(current_user.id)
        @useremail = User.where(email: current_user.email)
        @listings = Listing.where(user_id: current_user.id)
        puts'*******'
        puts @listings.length()
        puts 'Qqwqwqwqwqwqwqwqwqw'
        puts @useremail
        puts '******'
        if @listings.length() != 0
        redirect_to '/profiles'
else
        redirect_to '/listings/new'
      end
    end
end

def search
    @search_results_listings = Listing.search_by_listings(params[:query])
end

# def price 
#   if params[:searchp] || params[:searchpx]
#     @search_pricen_term = params[:searchp]
#     @search_pricex_term = params[:searchpx]
#     @between_range = Listing.between_range(@search_pricen_term, @search_pricex_term)
#   end
# end

 def index
    # @customer = Customer.find(current_customer.id)
    if  params[:home_service]
      @home_service_params = params[:home_service]
      @listings = Listing.where(home_service: true)
    else
      @listings = Listing.all
    end

    if params[:searchp] || params[:searchpx]
      @search_pricen_term = params[:searchp]
      @search_pricex_term = params[:searchpx]
      @listings = Listing.between_range(@search_pricen_term, @search_pricex_term)
  end
    if customer_signed_in?
    @customer = Customer.find(current_customer.id)
  end
end


  def profile
    puts current_user.id
      # if user_signed_in?
        @user = User.find(current_user.id)
        @listings = Listing.where(user_id: current_user.id)
        puts'*******'
        puts @listing
        puts '******'
        # @reviews = @listing.reviews
    # end
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
    @listing = Listing.find(params[:id])
    # this line ensures that the you'll only see the reviews for the selected listings, you won't see all reviews of all listings
    @reviews = @listing.reviews
  end

  # GET /listings/new
  def new
    @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
    @listing = Listing.find(params[:id])
    if @listing.user == current_user
      return
    else
      redirect_to @listing, notice: 'This listing cannot be edited. Please contact the owner of this listing.'
    end
  end

  # POST /listings
  # POST /listings.json
  def create
    @listing = Listing.new(listing_params)
    @listing.user = current_user
    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: 'Listing was successfully created.' }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listings/1
  # PATCH/PUT /listings/1.json
  def update
    @listing = Listing.find(params[:id])
    if @listing.user == current_user
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing = Listing.find(params[:id])
    if @listing.user == current_user
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: 'Listing was successfully deleted.' }
      format.json { head :no_content }
    end
  else
    redirect_to @listing, notice: 'This Listing cannot be deleted. Please contact the owner of this listing. '
  end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end
    # Only allow a list of trusted parameters through.
    def listing_params
      params.require(:listing).permit(:name, :phone, :address, :postal_code, :email, :description, :price, :image_url, :home_service, :aggressive_pets_accepted, :query, :user_id)
    end

  end