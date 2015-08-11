class CasedelayDelController < ApplicationController
  #咨询助理或办案助理为自己的案件
  def case_list_1  
    @hant_search_1_page_name="case_list_1"
    #@hant_search_1=[['char','recevice_code','咨询流水号','text',[]],['char','recevice_code','咨询流水号','text',[]]]
    @hant_search_1=[['char','tb_cases_case_code','案号','text',[]],['char','tb_parties_partyname','当事人名称','text',[]],['char','tb_parties_partytype','当事人类型','select',[[1,'申请人'],[2,'被申请人']]],['char','tb_cases_recevice_code','咨询流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_general_code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    c="(tb_cases_state>=4 and tb_cases_state<100) "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    #@case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_id,tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
  
  def ampliation_list
      @case=TbCase.find_by_recevice_code(params[:recevice_code])
      @ampliation=TbCasedelay.find(:all,:order=>'id',:conditions=>["recevice_code=? and used='Y'",params[:recevice_code]])
  end

  def ampliation_delete
    @ampliation=TbCasedelay.find(params[:id])
    @ampliation.used='N'
    @ampliation.u=session[:user_code]
    @ampliation.u_t=Time.now()
    if @ampliation.save
      @case=TbCase.find_by_recevice_code(@ampliation.recevice_code)
      t_casedelay=TbCasedelay.find(:all,:conditions=>"used='Y' and recevice_code='#{@case.recevice_code}'",:order=>"id")
      t_casedelay_l=SysArg.get_last_record(t_casedelay)
      if t_casedelay_l==nil
        t_caseorg=TbCaseorg.find(:all,:conditions=>"used='Y' and recevice_code='#{@case.recevice_code}'",:order=>"orgdate")
        t_caseorg_l=SysArg.get_last_record(t_caseorg)
        if t_caseorg_l==nil
        else
          @case.finally_limit_dat=t_caseorg_l.limitdate
          @case.save
        end
      else
        @case.finally_limit_dat=t_casedelay_l.delayDate
        @case.save
      end
      flash[:notice]="删除成功"
      redirect_to :action=>"ampliation_list",:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="删除失败"
      render :action=>"ampliation_new",:recevice_code=>params[:recevice_code]
    end
  end 
  
  
end
