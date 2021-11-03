public class Util {

   static List<Carteira__c> carteiras;
   static List<Mercado__c> mercados;
   static Map<String,Double> mapCotacao;
    
    
    public static void criarMassaDados(){
        
        setPrecoMarcado();

        //Adicionar Contatos
		List<Contact> contacts = new List<Contact>() ;
		contacts.add(New Contact(FirstName = 'Fernando', LastName ='Fernades'));
		contacts.add(New Contact(FirstName = 'Marcio', LastName ='Farias'));
		contacts.add(New Contact(FirstName = 'Maria', LastName ='da Silva'));
		contacts.add(New Contact(FirstName = 'Pedro', LastName ='Souza'));
		contacts.add(New Contact(FirstName = 'Alessandra', LastName ='Rangel'));
		//contacts.add(New Contact(FirstName = 'Rodrigo', LastName ='Alves'));
		//contacts.add(New Contact(FirstName = 'Paula', LastName ='Toller'));
		insert(contacts);

		
        
		//Adicionar Instituições
		List<Instituicao__c> insts = new List<Instituicao__c>();
        insts.add(New Instituicao__c(Name = 'XP', NameInstituicao__c = 'XP Investimentos'));
		insts.add(New Instituicao__c(Name = 'BTG', NameInstituicao__c = 'Banco BTG'));
		insts.add(New Instituicao__c(Name = 'Binace', NameInstituicao__c = 'Binance'));
        insts.add(New Instituicao__c(Name = 'Inter', NameInstituicao__c = 'Banco Inter'));
		insert(insts);
        
        
        
        //Cria registros  de mercados
         
        //Adicionar Ativos Primários
        List<Ativo__c> atvsPri = new List<Ativo__c>();
        atvsPri.add(New Ativo__c(Name = 'BTC',NomeAtivo__c ='Bitcoin'));
        atvsPri.add(New Ativo__c(Name = 'ETH',NomeAtivo__c ='Ethereum'));
        atvsPri.add(New Ativo__c(Name = 'BNB',NomeAtivo__c ='Binace Coin'));
        insert(atvsPri);
        
        //Adicionar Ativos Secundários
        List<Ativo__c> atvsSec = new List<Ativo__c>();
        atvsSec.add(New Ativo__c(Name = 'BRL',NomeAtivo__c ='Brazilian Real'));
        atvsSec.add(New Ativo__c(Name = 'USDT',NomeAtivo__c ='American Dolar'));
        atvsSec.add(New Ativo__c(Name = 'EUR',NomeAtivo__c ='Euro'));
        insert(atvsSec);
        
        //Adicionar Mercados
        mercados = new List<Mercado__c>();
        for(Ativo__c atvPri: atvsPri){            
            for(Ativo__c atvSec: atvsSec){
               String cod = atvPri.Name +'/'+ atvSec.Name;
               mercados.add(New Mercado__c(Name = (cod),
                                           AtivoPrimario__c = atvPri.Id,
                                           AtivoSecundario__c = atvSec.Id,
                                           Cotacao__c = mapCotacao.get(cod)));
                                  
        	}
        }
        insert(mercados);
        
        
       //Cria registros de carteiras de investimento
		addCarteiras(contacts,insts);
	}

    private static void setPrecoMarcado(){
        mapCotacao = new Map<String,Double>();
        mapCotacao.put('BTC/BRL',360000.0);
        mapCotacao.put('BTC/USDT',60400.0);
        mapCotacao.put('BTC/EUR',54600);

        mapCotacao.put('ETH/BRL',26000.0);
        mapCotacao.put('ETH/USDT',4580.0);
        mapCotacao.put('ETH/EUR',3950);

        mapCotacao.put('BNB/BRL',3187.0);
        mapCotacao.put('BNB/USDT',550);
        mapCotacao.put('BNB/EUR',481);
    }
    
    
    private static Carteira__c setCarteira(Contact ct, Instituicao__c inst){
        Carteira__c crt = new Carteira__c(Contact__c = ct.Id, Instituicao__c = inst.Id );
        return crt;
    }
    
    private static void addCarteiras(List<Contact> cts, List<Instituicao__c> insts){
        carteiras = new   List<Carteira__c>();            
        
        for(Integer i=0; i<cts.size(); i++){
            Contact ct = cts.get(i);
            
            for(Integer j=0; j<insts.size(); j++){
			Instituicao__c inst =  insts.get(j);             
                if (j == 0){
                    carteiras.add(setCarteira(ct,inst));
                }
                else if(i==j){
                    carteiras.add(setCarteira(ct,inst));
                }
                else if(i==j+2){
                    carteiras.add(setCarteira(ct,inst));
                }
            }
            
        }
        insert(carteiras);
        addItensCarteiras();
    }

    private static ItemCarteira__c setItemCarteira(Carteira__c carteira, Mercado__c mercado,Double quant){
        ItemCarteira__c itemCarteira =  new ItemCarteira__c( Mercado__c = mercado.Id,
                                    Carteira__c = carteira.Id,
                                    Quantidade__c = quant,
                                    ValorInvestido__c = quant * mercado.Cotacao__c / 1.1);
        return itemCarteira;

    }
    
    private static void addItensCarteiras(){
       	List<ItemCarteira__c> itens = new List<ItemCarteira__c>();
        
        for(Integer i =0; i< carteiras.size(); i++){
            Carteira__c carteira = carteiras.get(i);
            
            for(Integer j=0; j< mercados.size(); j++){
                Mercado__c mercado = mercados.get(j);
                Double quant = (i * 3 ) + (j * 2) + 5;
                
                if(j == 0 || j == i+1 || j == i+3 || j == i+5){
                    itens.add(setItemCarteira(carteira, mercado,quant));
                }
            }
            
        }
        insert(itens);

    }

}