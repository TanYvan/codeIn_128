=begin
创建人：聂灵灵
创建时间：2009-6-8
类的描述：此类主要实现档案案件查看时查看人、时间、原因的查看记录；以及的查看信息创建(lookfile下的new页面)，
修改(lookfile下的edit页面)，
列表显示(lookfile下的list页面)功能
=end
class LookfileController < ApplicationController
  def list
    @case=nil#当前办理案件
    @order=params[:order]
    if @order==nil or @order==""
      @order="recevice_code"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
    end
    if session[:recevice_code_5]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_5])
      c="recevice_code='#{session[:recevice_code_5]}' and used='Y'"
      @pages,@lookfile=paginate(:tb_lookfiles,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
    end
  end
  def new
    @lookfile=TbLookfile.new()
    @lookfile.see_date = Date.today
  end
  def create
    @lookfile=TbLookfile.new(params[:lookfile])
    @lookfile.recevice_code=session[:recevice_code_5]
    @lookfile.case_code=session[:case_code_5]
    @lookfile.general_code=session[:general_code_5]
    @lookfile.u=session[:user_code]
    @lookfile.u_t=Time.now()
    if @lookfile.save
      flash[:notice]="创建成功"
      redirect_to :action=>"list"
    else
      flash[:notice]="创建失败"
    end
  end

  def edit
    @lookfile=TbLookfile.find(params[:id])
  end

  def update
    @lookfile=TbLookfile.find(params[:id])
    @lookfile.u=session[:user_code]
    @lookfile.u_t=Time.now()
    if @lookfile.update_attributes(params[:lookfile])
      flash[:notice]="修改成功"
      redirect_to :action=>"list"
    else
      flash[:notice]="修改失败"
      render :action=>"edit",:id=>params[:id]
    end
  end

  def delete
    @lookfile=TbLookfile.find(params[:id])
    @lookfile.used="N"
    @lookfile.u=session[:user_code]
    @lookfile.u_t=Time.now()
    if @lookfile.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"list"
  end
end
