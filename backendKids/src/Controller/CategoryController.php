<?php

namespace App\Controller;

use App\Entity\Category;
use App\Form\CategoryType;
use App\Repository\CategoryRepository;
use App\Service\CategoryService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use OpenApi\Attributes as OA;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

#[Route('/api/category')]
#[OA\Tag(name: 'categorie')]
class CategoryController extends AbstractController
{
    private $categoryService;

    public function __construct(CategoryService $categoryService)
    {
        $this->categoryService = $categoryService;
    }

    #[Route('/', name: 'category_index', methods: ['GET'])]
    public function index(CategoryRepository $categoryRepository): JsonResponse
    {
        $listJson = [];
        $list = $categoryRepository->findAll();
        foreach ($list as $key => $value) {
            $listJson[$key] = $this->categoryService->categoryToJson($value);
        }

        return new JsonResponse($listJson);
    }

    #[Route('/new', name: 'category_new', methods: ['POST'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "title" => "Painting",
                "description" => "teeeeest"
            ]
        )
    )]
    public function new(Request $request, EntityManagerInterface $entityManager): JsonResponse
    {
        $data = json_decode($request->getContent(), true);

        $category = new Category();
        $form = $this->createForm(CategoryType::class, $category);
        $form->submit($data);

        if ($form->isSubmitted()) {
            $entityManager->persist($category);
            $entityManager->flush();
        }

        return new JsonResponse(true);
    }

    #[Route('/{type}', name: 'category_show', methods: ['GET'])]
    public function show(CategoryRepository $categoryRepository, $type): Response
    {
        $category = $categoryRepository->findOneBy(['type' => $type]);
        $category = $this->categoryService->categoryToJson($category);
        return new JsonResponse($category);
    }

    #[Route('/delete/{id}', name: 'category_delete', methods: ['DELETE'])]
    public function delete($id, Request $request, CategoryRepository $categoryRepository, EntityManagerInterface $entityManager): Response
    {
        $category = $categoryRepository->find($id);
        if (!$category) {
            throw new NotFoundHttpException('category not found');
        }

        $entityManager->remove($category);
        $entityManager->flush();

        return new JsonResponse(['status' => 'The category has been deleted']);
    }
}
