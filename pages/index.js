import fs from 'fs'
import path from 'path'
import Head from 'next/head'
import matter from 'gray-matter'
import { sortByDate } from '@utils/index'

import Post from '@components/Post'

function Home({ posts }) {
  console.log(posts);
  return (
    <div className="container">
      <Head>
        <title>Dev Blog</title>
      </Head>

      <div className='posts'>
        {posts.map((post, index) => (
          <Post key={index} post={post} />
        ))}
      </div>

    </div>
  )
}

export async function getStaticProps() {
  const files = fs.readdirSync(path.join('posts'));
  
  const posts = files.map((filename) => {
    const slug = filename.replace('.md', '');

    const markdownWithMeta = fs.readFileSync(
      path.join('posts', filename),
      'utf-8'
    );

    const { data: frontmatter } = matter(markdownWithMeta)

    return {
      slug,
      frontmatter,
    };

  });

  return {
    props: {
      posts: posts.sort(sortByDate),
    },
  }
}

export default Home