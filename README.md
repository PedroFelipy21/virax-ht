# Grupo Virax — Painel High Ticket

Site estático (GitHub Pages) + backend Supabase (dados em tempo real).

## Ligar os dados reais (2 min)
1. Crie um projeto grátis em https://supabase.com (New project).
2. SQL Editor → cole o conteúdo de `schema.sql` → Run.
3. Project Settings → API → copie **Project URL** e **anon public key**.
4. Cole os dois em `config.js` e faça commit (o site atualiza sozinho).
5. Em `schema.sql` (policies) adicione os e-mails da Clara e do João à lista de escrita.

- **Visitantes**: veem o painel sem login.
- **Gestão** (e-mails autorizados): clicam em "Entrar (gestão)" → recebem link mágico por e-mail → podem lançar vendas.

Sem config → o painel roda em **modo demonstração**.
